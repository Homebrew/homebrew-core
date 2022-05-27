class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.2",
      revision: "2f1e50cc31b960b1a975f2ebe08bd17be9a5e575"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf8f6120c113a4c0380bfffcc6ff965ec512cfee2bea45c5f29b8b2962ac253e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e66090174a30e9215aae170301db0ad5118cbe313dffbfd354cc3622036ac62"
    sha256 cellar: :any_skip_relocation, monterey:       "4aae4fdcfe0ec7eb5f0b10e2a1b5b061d35204019d6ebfddf05cd9414a87565a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb0d45e02e9e406cd9564d381656b202dd39f9c14f3c03d99c501ecad2dbaf9c"
    sha256 cellar: :any_skip_relocation, catalina:       "a32ff9e323b461b761cb493438d52aebaec495bd98267f4033a6a4501a2d38db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e11f9ee4d42609650797bdf909a0b03fc31396e8035003a8de498b4a8a3a48a"
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
