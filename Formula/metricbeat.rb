class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.1",
      revision: "7e56c4a053a2fe26c0cac168dd974780428a2aa6"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe8d702210bca63cc65c056c7936078972a69d58792acbe4bcdf9345d4657e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a7c1ea7efac68b4165b8b9356e257c46e1c4d6ea82af7b918a634e76b70ca12"
    sha256 cellar: :any_skip_relocation, monterey:       "5f70fc5478b638645aee3f9b24de46cf0dd91265eb0aa00d5384aa3ff3e3fbe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b77c4a88b5a6ab47db4c21a9d9113fe9a1a0601df27bc506c58511e9f1ec05b0"
    sha256 cellar: :any_skip_relocation, catalina:       "7594fc4e0c908c54237cef9eaf166a1623ad315f30707d5c46109294e554e64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12b0a2b59b15d0988182958bf92f602e206149700daf176069a0d1614dbf68e4"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

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

    sleep 30
    assert_predicate testpath/"data/metricbeat", :exist?
  end
end
