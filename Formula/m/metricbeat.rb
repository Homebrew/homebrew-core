class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.15.2",
      revision: "26daf71e4ec87172523af7f0e916cba9f79dc0d0"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ece99c83b50d7034fa9f25820ad5e77cfd737fe7ddce74ef73fa0702e91adad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01c955fc6f03b33fccf4d33e98bd7e37d24d893300d675b7ce0d85ee695b8e91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ace58481da357a6a1f97d278decab2d16f6695399df05e5c20dabc3f769bd46"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ca12fa97eb1cdc8a2af954b9000315e2db34ed5cfc95d28f340163152fedf75"
    sha256 cellar: :any_skip_relocation, ventura:       "207c90264007f516c6759c5a66b0e71dac61a56b07f453620db5908b1021330a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd97d980e5f9cfacddf23582658a5a5e5760a76661f9525614d507d1286a94dc"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

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
