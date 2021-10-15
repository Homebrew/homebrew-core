class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.1",
      revision: "5ae799cb1c3c490c9a27b14cb463dc23696bc7d3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0f47274e6a9225f42907ce2d4a4c352f38685b3e91217ef0bac0f26ad674934"
    sha256 cellar: :any_skip_relocation, big_sur:       "294b316138c29b373cb3d7cd6f5416233af362f62a67feea6f6908cf35348f55"
    sha256 cellar: :any_skip_relocation, catalina:      "c4803fa1e16677e8c510947c3c242d53fee6daff5385f80ed1a77e889fe692ab"
    sha256 cellar: :any_skip_relocation, mojave:        "9fc0a2f697cf17627c18133e192e20062e4b45ad1ee539829f5bae5e71327ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1a733de765ab8c0ff6083dcb324f67e80d566177b50173c4f7d8ca3fc33d67"
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
