class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.3",
      revision: "1755b5dd3127bf755ee39deb25a802438bdac620"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e43ecab7f144063a0c4fc8361b0a77ca4da3cdc7a8be47c66228d85cb0f50c7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e312404611babc0fa98de3c91deb6b335966a2458957004c6e9b85742e3327ff"
    sha256 cellar: :any_skip_relocation, monterey:       "c0c3dbe3726efcce4fe38eb19aabbb08100c1825ee1ca01600c20b08cb0c58f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a502e935e5d2dbdaf8d7604a79eae2ff5fc03d83498dfa91464ff2e1bc4b42a"
    sha256 cellar: :any_skip_relocation, catalina:       "a6e9a25049d8eeedbb183c4981fb3c658385d59e73daa6070d2c277a0e1ef58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a823ecf16775b51ff7094a4b0848cd07c4530787d6dc4f466a715c0fba1283"
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
