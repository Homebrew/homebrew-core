class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfc84e22cce29ff637ae3a6fdadab987eb961221b0cbe6b31a4d10ac59e35823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92d30c97809248e5c77b7adefc79c255b002dad4e30693ed88b035fade1edbe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1341e5e7987a85e22b55fb434c4d3cc3d2d3a693d6bf855e18399aceaa56cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "66e34711a69962fcb2ad84f0d95372ba5a96d0989d68f428d9cdedbcec7606ae"
    sha256 cellar: :any_skip_relocation, monterey:       "6176874218faa5615235a334cb7674c841b3bd7f3d8cf80a19a654fbebe8ee21"
    sha256 cellar: :any_skip_relocation, big_sur:        "178e80585e58f31eac776b0d8efe17c908b927eb6cc86f30ad017c5e8d41ffa5"
    sha256 cellar: :any_skip_relocation, catalina:       "329cc521d8fc10782d9aeb6f7abb84e12228c247660ea34013f5719840c8e4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b752c4857764b239a1c6fc13713b3f4bef2c7b3dfea2d920a9bede6fd9656d"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, includeList, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, includeList,"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"filebeat").install Dir["filebeat.*", "fields.yml", "modules.d"]
      (etc/"filebeat"/"module").install Dir["build/package/modules/*"]
      (libexec/"bin").install "filebeat"
      prefix.install "build/kibana"
    end

    (bin/"filebeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/filebeat \
        --path.config #{etc}/filebeat \
        --path.data #{var}/lib/filebeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/filebeat \
        "$@"
    EOS

    chmod 0555, bin/"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"filebeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"filebeat"
  end

  test do
    log_file = testpath/"test.log"
    touch log_file

    (testpath/"filebeat.yml").write <<~EOS
      filebeat:
        inputs:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      output:
        file:
          path: #{testpath}
    EOS

    (testpath/"log").mkpath
    (testpath/"data").mkpath

    fork do
      exec "#{bin}/filebeat", "-c", "#{testpath}/filebeat.yml",
           "-path.config", "#{testpath}/filebeat",
           "-path.home=#{testpath}",
           "-path.logs", "#{testpath}/log",
           "-path.data", testpath
    end

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_predicate testpath/"meta.json", :exist?
    assert_predicate testpath/"registry/filebeat", :exist?
  end
end
