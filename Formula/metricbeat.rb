class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.3",
      revision: "c2f2aba479653563dbaabefe0f86f5579708ec94"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff6df859a3e97edc880468a3e1753b74ae0d62db4bd31b30ccc378c78f950a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17a63900be843d399d9b6ea2129be424f5ba8937d0236645e73598c42ef4964d"
    sha256 cellar: :any_skip_relocation, monterey:       "6771a3a223839905f4a6665a9cc476d5e145cbe64fa050afb111741ad1e86d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e96a7c39f3b28c1624b0b86894967a22ca5ba44927da8904da8ec104919c7400"
    sha256 cellar: :any_skip_relocation, catalina:       "15c8abfb93924f28e2ffa70ef4c0da56dfc159bd389a96c87552322a183a418e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc03043a09a9863efbb65bb4ccf02f2b043c3598e050da1ed6726679ac40c6db"
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
