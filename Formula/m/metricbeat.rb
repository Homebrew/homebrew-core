class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.15.0",
      revision: "76f45fe41cbd4436fba79c36be495d2e1af08243"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d24dea8e10f9135558e53dfae6c911de7ccaa18e1c477f175e2d522b41296cb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bd0468c4227fe5b1062027923ba2c2534136b8c682c1199c5d3a56510d4d529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2f5980cf5bde575e1677e9c69de67f28a31df9f764d12ca5df2fc996b52d5be"
    sha256 cellar: :any_skip_relocation, sonoma:         "0357d35d9e5d7d4ac67bb8719fa8c05320fb9deb5116e72f2757550f95197c27"
    sha256 cellar: :any_skip_relocation, ventura:        "d085681f98b4ac39a29543af5bc0df7a8e7fac3150e99d9a8f83064d95d83076"
    sha256 cellar: :any_skip_relocation, monterey:       "1734da64bc87320729bd562cde53c4bf058f5064cfa1bd6d0becd3f0cd25fe87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b7883dda95fbdd6a577fb256c564e9971b539e4ada029023e719a5f9031322"
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
