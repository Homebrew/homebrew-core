class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.3",
      revision: "7826dc5e91c6e6d2487e05d3a8298f49041cd5c2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d64e17de0862d045c2e8d5a07531d8c51dfa89d683a958ff619da32e2a4bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21d4c689e56d5b3c7afe718f2d7f0e41d0f19c31451e79ae32fbf82effd7a41b"
    sha256 cellar: :any_skip_relocation, monterey:       "3329926a58f56e80782ffaec04c5f2b05f66e8eb645fe089c9a12c178dd590ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c1c62de1d094bfbb4fe018706844f4559977cf8573d084af7bc26417dc1221a"
    sha256 cellar: :any_skip_relocation, catalina:       "96780f042227aa2ed4693ce6bc86e2b7a7613ff686fd97c1697416b3b873e754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fef24fdae7883100d1122eb4bf22eb8161b8f4e77278f1878526fedfded366cf"
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
