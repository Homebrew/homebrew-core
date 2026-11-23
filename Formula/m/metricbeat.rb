class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.7",
      revision: "9455ccba703306aae4ed36b86a03976c963c0186"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    manifest_sha256 "fceb53ab7caaa87544a4c67b6d49fc2055f6d59a753e87e8f10b36b512e1a863"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cb8addb4ef2ebaec3bf2ee72338a1a0dc9f14de4647d96f7da9ff495f383e78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb33d12c1e2c4e5b41da560ea38e9b2766df5bbe7f9ab9b39a34853d9b9cecb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82c68db81a11ebcff7b74b99e772fb7c062ae797c2b626d27a6f5c9dd79bca99"
    sha256 cellar: :any,                 arm64_linux:       "fadacb9af77fdc5aec2605275151619e8f141b2b5191423cd221ca50e96d8a94"
    sha256 cellar: :any,                 x86_64_linux:      "3d030b7f7f6511ae2de8b9c8b25f6a5e7e4c212d1aa99a3df88e5f38fe29b30a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

    with_test_process(bin/"metricbeat", "--path.config", testpath/"config", "--path.data", testpath/"data") do
      sleep 15

      output = JSON.parse((testpath/"data/meta.json").read)
      assert_includes output, "first_start"

      (testpath/"data").glob("metricbeat-*.ndjson") do |file|
        s = JSON.parse(file.read.lines.first.chomp)
        assert_match "metricbeat", s["@metadata"]["beat"]
      end
    end
  end
end
