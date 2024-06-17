class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.1",
      revision: "c74896ed7acbb92921ee46fa5e3d66d575a8b0a9"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee8e4cddedb87fb913deee8e75f7c37bb70d7be142625b7d5adaade4492b4bb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7022b5a6a1169b36bd97e3196c9ba23f84818b35b60791c3a7fb6f33f041edc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b5b7e31d0907b4cd3eb584e95642728c6253750b189e5a58881f7d8cd54b3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f83268dfea66373993d00bd97e6880bd987ef03ab7e4e4b64c69dfc026e6e90"
    sha256 cellar: :any_skip_relocation, ventura:        "eb1a04a389d4532d18c7a184dbeec941a6f0c5f3457b2f2443ca4585ae7d3291"
    sha256 cellar: :any_skip_relocation, monterey:       "a6ae756087797e6e296a3a1a0296aa8b45eed7edf82ec789468661566a4ae9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8139561e64237fac866e8a7031bdafc1634a775462f902a607d19c7af1f574"
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
