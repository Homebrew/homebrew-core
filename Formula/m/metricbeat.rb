class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.3",
      revision: "3747d0eb6c26247477dd62ca51535cff8d6338b7"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bda4a82890f681461be8ef247cf768f1ff6674eeee0fa877312bfbb6d2da86c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b96902fc401a2c4be40ba9da5d6756edcd0375bec3a519b3e07ab65af3a6348"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40ac22dc136930b36d2b2c954f9154b593cd7f76171e5512e94eab03043db06d"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a69c5e2484d97ac40f859623efb630805c7eb0e87e71b088a1c4bfb46c01d2"
    sha256 cellar: :any_skip_relocation, ventura:       "392864efe4edd9b35a0827680b2a5557fc01a76c472a8cfbf3061faeb9c26667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35a623b9fa298db04c08d7c4b4f174a62e8cf31d315bb0ad3f552b38cb6e012"
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
