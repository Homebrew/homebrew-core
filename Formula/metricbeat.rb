class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "429e99ef9b8d14194a855d553f347c85adf11c4486f5ebcd2c6c894854d42001"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2176b07912f3aec9942fb426d214a48e40eae70bd179c217df99088131d136a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d92022855ddf451886ed0af4508906fac05c206d05a20de37928c0cbc80c8da"
    sha256 cellar: :any_skip_relocation, ventura:        "d256dc00a6cc7125cd4c91ca5f3efb52e55dc93141c2a2662e5135e9d221348e"
    sha256 cellar: :any_skip_relocation, monterey:       "edc93b09a03d169ea341da4cfca6e8518cb2da73ba2596829e24ef641efebdcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "13c53a6d444e1193c804f39849ff70cbfc1da2f081d068efc32a6420703c6c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208a5c48e1fc6364ab81ae6d6a4219abe5cc5d633c1ac9f63318f340e88f2b17"
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
