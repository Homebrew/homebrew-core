class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.2",
      revision: "fd322dad6ceafec40c84df4d2a0694ea357d16cc"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0afe68820ec5233979bc019d3376d59441ff76cc04b90dc9c82020854fe8301"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0abec415cc3a756583e2ecb831d6264869d18a5ac02faae0097b5d3b141335c8"
    sha256 cellar: :any_skip_relocation, monterey:       "3228c5a4d0963f3c56bdb128f930eb04cf5ecbce0a062ae7baa49c99d0ad9658"
    sha256 cellar: :any_skip_relocation, big_sur:        "af1e9a8ea6438c0cb0d5eb742e5afc8b95d94f0c30ac9424ead1dc942c55e1bb"
    sha256 cellar: :any_skip_relocation, catalina:       "e5c99b0b0a2188403979317b4911e5b5bb8521d17c84e0c449be65009f25dfbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f4fadd93b78a4de8ca92ea6d463613f8c144fff093dc1341b20fdf85f4ebadc"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.9" => :build

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
