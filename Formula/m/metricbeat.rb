class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.12.1",
      revision: "c7ec8f634ed6052674762b32fa640087d32f165f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7085a74071cf46a58694dc2a3a0544e2b387d63838318869804d30ffbf88be47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "746a430fe56b4196a3a5a7f05319dee1442b730aaa387796d840cbba749ba592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56bc27a9e9d6a9b6b774ed699761f9bbbc4d943e824a087f732665468acf99a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba958ad9ec9aedb28cdae91d0425674a25113f60282ab20e077957f618953ba1"
    sha256 cellar: :any_skip_relocation, ventura:        "a2af99c9c69864ec3012ef0a45d94d38e6546e9dabf0eb9376a6a5edc2a6ae9a"
    sha256 cellar: :any_skip_relocation, monterey:       "e7e76aeacdc5990139edc392f06c434f6941aa3f0aecb1c077e08724414f89f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f337c5c09f154685b113e08299eecc88088701338722a6a27816a9d962bd9228"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

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

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
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
