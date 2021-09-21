class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.14.2",
      revision: "574c21d25ddb65a63665ac26b54799f81a7e9706"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fae3f269ce932b35cd26f99f93686d82f1eaf508dfcf8e3722fb0bf212dffa30"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e0f626fd2ae5c00394ec6c0d0cd5376c8a0045f8405dd05156f61ea5b3b101b"
    sha256 cellar: :any_skip_relocation, catalina:      "9a56ca3180b86193e96f8ffc8dd1413a257772d8fdfb525139ddbb5ba4e78ab4"
    sha256 cellar: :any_skip_relocation, mojave:        "2eb502f2f97ad30dc45b8906f770d2cf3485df9936e3b07023c424ea575db548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c7373bd8ba57b76b991c8bd7e5cfd10bbc6df1583f098327435acb2d89b1dd"
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
