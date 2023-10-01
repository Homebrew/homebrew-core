class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.2",
      revision: "480bccf4f0423099bb2c0e672a44c54ecd7a805e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f639c8e0b4736ba37f49f9ae8a3d18eaa10078e674ba6c09701fbe8057522f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6cc086d686e791a8ba52f201b34b671faba2f39d4c0c1acd35c292bfa42e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "818d16145abb9967e99f1ca576f677ca5fd36e77bdd56d33b6ea2b30c47fabc4"
    sha256 cellar: :any_skip_relocation, ventura:        "4c12ce951939b759d8038dd7ca7296ab4c44786ad59c87b3899d0e654456d436"
    sha256 cellar: :any_skip_relocation, monterey:       "96b78c7490e8e21ce6380dfd1b148981b4e0148f86ff97aadf725d7401189428"
    sha256 cellar: :any_skip_relocation, big_sur:        "373fae43ffe96db920595e7d27a0000bef360a69f7b2c9f2ddcbe074e505d2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bce68645f8168e90fa7c735b5298cddfe8bedd024966d5cd31e4d82be47cb42"
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
