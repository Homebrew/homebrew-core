class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.0",
      revision: "2ab3a7334016f570e0bfc7e9a577a35a22e02df5"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b2ceaa0f71828345bcf5fb8e5c70d1cf64d51507a20bfdb9f81c262f333398"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "855cb1614cd6ca7f31241f1dbc57d5707e64543f56bcd843d85e2c4b067f8017"
    sha256 cellar: :any_skip_relocation, monterey:       "70f790c3f9649ab78e5e6935708ec03e55d0bd83257b5dfcdcf4e5a2b821ab4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7d76b3a0dda75b48461c51dc637595a4b779ccc2dd09f9d71116b7cf03287e1"
    sha256 cellar: :any_skip_relocation, catalina:       "4375da87ad4488c40524a93d7d62acb7c598fdd521df62bba018f96cc9955a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b03ab6c2410170ced1a7065dc30ac22a25c31301d4974ed978c20278c6263c9"
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
