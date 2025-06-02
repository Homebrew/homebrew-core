class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.1",
      revision: "bce373f7dcd56a5575ad2c0ec40159722607e801"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "855b4056e9dfb1a13f2af2647ccd65f1891fbe693530e0aa21242b8a3aa7b8af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52e91099d3af4ef488dc5dbde3552d92a426d2617a76bc52216cf4c148228b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "077b31d7881455128ac761ea9b3a19ca10c59ce336b6742c365f81c7128d4c64"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ef9e9148bb93e99acabd6bf9ece0c5774c4f791ce82226146f7d4e298835fcf"
    sha256 cellar: :any_skip_relocation, ventura:       "fbea922f1f94630bcccecbb8deca76e4f8cee3fe4f580ef43bedd260f8a1149d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9df91e264926fd73d167e8925c10862741aafac4010a9d887a3e18cb7de1fd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f32bea95151a59f2f27b43c5cd335449ea9fb53d393a7f761b3b124e5c1357"
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
