class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.0",
      revision: "26aad5d437d592cea2d8d3e0b950f885ff47fe41"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6084e5d73eaaf080da85aef01dce82dff812fd18b9f29a6bf1add4aac83f273"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008a3cb836ce07c64454d8c86aad0b15bad4c13a8b17758fd5063dcc80e15d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf816321b2bf1b85207414ef518e07591c62d183ae81963088fd05c132182c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f52ca44a965c1010d28afce9222d197ae647e184144e2aa199402a3f1296016"
    sha256 cellar: :any_skip_relocation, ventura:        "b0f0983ab4c400c6dd1878c598a5c497ae73ac9e1cc62f89ab7919fa017f10c5"
    sha256 cellar: :any_skip_relocation, monterey:       "33ee2c3de5606180de6884e92f84e21457a95c5dbfd41ac0c49fb45eef515299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ab08d060a28617ef4bc0916f5ad17f1bec02d8cbc30103ca1a2a1e5c111d5f"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

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

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
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
