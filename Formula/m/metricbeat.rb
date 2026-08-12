class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.1",
      revision: "53197d5422766e985c2aa0f56607750d34d0e912"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2863728cc3dc93d9d04b540de47a46bca0c5d70abdd552e0094576e9085d6d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8c6fe63a96db5cc9c6e2920f1a8868df1fd01d781d7fa91bdd721a7a6c1e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2b6062dcd9d5f32813bd01b43ec17441508c09423c1f148711a02ad5008f5fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d89a9d3442e25e41118d23130ec26149c5a7b6627ffa0eb8dd21e76ac5a85133"
    sha256 cellar: :any,                 arm64_linux:   "0e9132f40fa48d0c57be33ea8865c3dba7d7b0ba1a136c79b3fd2d5ec4c80883"
    sha256 cellar: :any,                 x86_64_linux:  "a80b1f8534ac41bfc7a8e3e9b326ae62c0c51c7861be815aeae8f9b3f490630b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
