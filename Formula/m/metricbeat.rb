class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.3",
      revision: "bfdd9fb0a3c4eeeacf5a5bc2110164a177e4cb08"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d00ec806fb82ad267bef8870f2bf85c1e69a1a31b140a6351d4ab73599e0e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46f81cc1e1e9e846c6bcfe4ab626de9cce67c43bc2efb49d1d0e6bf49e8a11fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0edcfaab3b35ef54284dda2126cbcd4f22fbec928b9c3609deea2208d12834a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "688e97e1f200d4caf283f9cbe208cd38c9fca7c402d426eec9eefc51a604f99b"
    sha256 cellar: :any_skip_relocation, ventura:        "1094b92126de2f69f62219f6a739071a903c1df817e77d1a12ef07a3e7550f94"
    sha256 cellar: :any_skip_relocation, monterey:       "0447b133a11a390a2c1d0172a1ab7e85c2b9223051a53923d52f7d7d7e7cb829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60793e278cdeb749251a3e4900481223464e2033afd84408ff2c260e7ec6f92a"
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
