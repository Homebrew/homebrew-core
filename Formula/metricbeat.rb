class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.0",
      revision: "6d6754fcb0adf6a2191b055d35f694c961c8ba40"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce407ee9b2c02396fb0764620292e574024031a2290be2071800a5d05ae7bf62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3525ac961114acfcf5ac224cc1009d02bf3a6c6bf53b7fe1c14a3078fe209d2a"
    sha256 cellar: :any_skip_relocation, monterey:       "05eee8fa3c3128747567e859c66e264debab8544756adefee4bc0fe071518d39"
    sha256 cellar: :any_skip_relocation, big_sur:        "958d35d64c06d40c7dcdc29b7df3f71c3dc9b5b9408126136303182d6b80e81d"
    sha256 cellar: :any_skip_relocation, catalina:       "42f57156f89b00c2a09f457779bf923397818bd30a91fbfaa1cab46aa719ed4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0158d704066224941b1ba9a8daa55408623526d4e7fda879c755a2c6a3d98f4"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end
