class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.17.0",
      revision: "93708bd74e909e57ed5d9bea3cf2065f4cc43af3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70acc8e7f1afa5cfdca8b1adb6dc1232da52dc27016141f1a90613504f17bc48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d16008d5b6fe090655ede666e9fecb953f4776e72d790bcc746906935a6b7ff"
    sha256 cellar: :any_skip_relocation, monterey:       "03005c7765a3a148ebb0fb37ceda111e28a8bb3b30f349fe7424c08e06f46f8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "388af0a6475f1551f4d9e639ebc884bca4d4867ddcbf7656380df8e3bcaab7f1"
    sha256 cellar: :any_skip_relocation, catalina:       "b8386a097ad81d2f2227f69b05d1f3aa0d429a22ea4be3347e549f276609f51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4969a3cf78c692cfe260530cdd588d04265d1afd45ca3d23bd22cde5c8f1a067"
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

    sleep 30
    assert_predicate testpath/"data/metricbeat", :exist?
  end
end
