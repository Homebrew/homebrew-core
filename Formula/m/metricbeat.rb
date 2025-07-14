class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.3",
      revision: "c394cb8e6470384d0c93b85f96c281dd6ec6592a"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d388a0685606f7043a8bb5e3ea65e792b5fc028a6dd39831a9aef8e4cc5a29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "314a5e4f7d1da59bc767493777d633ad3c4415cdce8edd81ceb2b7ca812807a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91ab55825ecb0b1c15293f05cdd53729c42b3c909dbcd4d6be4eb08991060a16"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3aa810413fc3afd7d190f8994691482215460b3d80590dad1cd3ec62181cb76"
    sha256 cellar: :any_skip_relocation, ventura:       "b81e6fb1f9f8584baf0930680159c3c53cec9631ea9de0e5ee4711a57ddec1eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a6ed5659441196da9a9f2315c0b0534264e5a9bc0e235f0bc6508de3fba5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a3ac38e2d985592d037234f19e6548b98f8c6340d547ca4d1c36e92094b698"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    SH

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~YAML
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    YAML

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"metricbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
