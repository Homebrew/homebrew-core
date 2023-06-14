class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.1",
      revision: "7ba375a8778fe6c1a61376a6c015e8cea71caf21"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ff3cd22d5e25563fc5234786bb99bf32ea61c4239ca41c020edb4485a2b5b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00b0b93f816260e3c20e4449717670a486d84c988667aa444581c3efab01a8d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eacb41e07651bb3aa543072227fd5245d93cc04c04cfe0dba87d447fc5e43cfc"
    sha256 cellar: :any_skip_relocation, ventura:        "4332611b28e84bb39f7dde5a2c184bebebbf1ecd275e87d8e0d2f0b8ca696ae7"
    sha256 cellar: :any_skip_relocation, monterey:       "bc5a890f25330fb9cf6d1f81eab1d918d01df61c2d4ce1b2968a7c54452eeef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb6cb976e90b7cdfbe933e4409c059df4ba9cf6c2e63952d349a5f22d6610d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d07c97f8f97571e6c564fa55e9e35b8129d1395bb8023194ee00ab0537e94f"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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
