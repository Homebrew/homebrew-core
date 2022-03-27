class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.1",
      revision: "7f30bb31a4a532c865161efbbdadd012323b04c5"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b7fdb79b93e504f4529212d2326dde71b82f023525a25be202fc9506ec3abad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e07b889d25c94dc879e9aa7086e28db3decb050bd4ecab4f77505936449970c2"
    sha256 cellar: :any_skip_relocation, monterey:       "714b271ec44b45be437db0125028b0b1e94d0271acb3b1b3792d4111176b1c32"
    sha256 cellar: :any_skip_relocation, big_sur:        "07a2b5ee52baca1ca3b2fac380b278c9a22100efe0a742c2679df9fa4e0556ee"
    sha256 cellar: :any_skip_relocation, catalina:       "48f6a18b42da82514437b049531b639e8f9099ea36da5d708a0c09776d5bd5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f62ad81d8feb97afa43520c30100faa00eb600ff619a099c7306dacd9ebe700"
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
