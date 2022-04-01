class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.2",
      revision: "6118f25235a52a7f0c4937a0a309e380c92d8119"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d8bbd47a01ee7a2e2050471e7d58c191249fa7a4cb1a59f75f563dc0fcff68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf39a768fe32dc1b66c7948b6f81eac9e51c4c1cfe04e141c0339450dc672b72"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ed378d26c719b6e1afe9fd4deee02152df56b0a2a52c7ecc056084872ec057"
    sha256 cellar: :any_skip_relocation, big_sur:        "0241ae2b22a7f2fb4bb272be83895b5a269b9321de9fb64ce19c1e558526568e"
    sha256 cellar: :any_skip_relocation, catalina:       "bc325348bdb90bc8f779a4364d6c5f080e1e5d2f7c980a4a6ed11d52587fb84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37cdca85dd000cdac68fb98e3612fe9c2e3794438e6b3c71f618860ff16789f5"
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
