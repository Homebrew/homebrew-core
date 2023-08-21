class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.1",
      revision: "3799398872c0f33da4e65019390d055cdfe633bd"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e12bbf079933e1ec1f4b4f18259d3379eae94f0010d7e1cc6840b3450c713680"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4af7f21fd421da1601963ec5325e03927eb587b94717a6761b5868c10652a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "465c48344aa2e4059ab90063d5407430ad36c409719beb21ffa4c552a58cb8a1"
    sha256 cellar: :any_skip_relocation, ventura:        "bfb60492474ee830906a1d23fb596814ba9f04757a743f87bdcdd044589bbc25"
    sha256 cellar: :any_skip_relocation, monterey:       "1dc464c9ae6b51355932eafdc90340d6f7b4cd209a907d2f73c694c9807dfb7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2848cd520586b9173f10926e9f7294d5fcafcc040f5a9ee6671110fae87b43f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927678aeb5ab04d24f6d63d9becbf15496a0328306a7583ffbe1a4539447608a"
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
