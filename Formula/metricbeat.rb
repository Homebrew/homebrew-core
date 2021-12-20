class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.2",
      revision: "3c518f4d17a15dc85bdd68a5a03d5af51d9edd8e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28c38d8b425cfeeff84bf73c4107725a76184d6495cff6bea75a53275213efee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5c22f16161653c337248418feb7d8969229c0cc042d3cbbd15f8b93ce38b66f"
    sha256 cellar: :any_skip_relocation, monterey:       "c81a7105379ae7a9369022d441dcb0a7d3bebc8825c71d40fa9b2f681828e5bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f1158be7255aa647914c382cbd64bc675813aabc71728270b2cc857917d9094"
    sha256 cellar: :any_skip_relocation, catalina:       "21fd52ffc9691a978061e05c95d99a3d9319f55912961729806edd2ed3f56225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be8b1326f7deab2c6d0e188afcc16b274560fe24a8678dbd46eeb3b3a427b934"
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
