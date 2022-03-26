class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.1",
      revision: "7f30bb31a4a532c865161efbbdadd012323b04c5"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a015c013ca48e190a61d911974a2ce2ec0e7d8424c0d194d65cfc3b40aff938"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c414eaa9107f87a73f048ebbb0a63502cbbc0a6acba5e31d7481d2d12c55d047"
    sha256 cellar: :any_skip_relocation, monterey:       "85f1a010828f90830cb2560391f54315cf31d34b5d3e209925efc655ca6968da"
    sha256 cellar: :any_skip_relocation, big_sur:        "a87862f10f744e3c32b765fe8e645db2cbfedd6d21f8e4599de23105bc3aad97"
    sha256 cellar: :any_skip_relocation, catalina:       "45e13aceb18d11a059a428ab1f8945aefce8551307043b30c99e04c1449606d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc27b0e2051d361b751b3a9b34b18b2ef441a3d8b250094cb9ea84021553f6b"
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
