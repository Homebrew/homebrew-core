class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.1",
      revision: "6e9dd49b5da9c045125078bb95be9f0dc27e8263"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d85e4554aa4e54435e04119d58c659d10b0f7f5f9842bfacf44d3840ed03c2a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78d3e3d7715ddfbf819933d7010d42039c1dd8d095cdecfe66f74bce7e2ff5ae"
    sha256 cellar: :any_skip_relocation, monterey:       "2e3afa981e7c8a4314324996cd9af4a93338cae94b5a323d4b43d53fa804ea98"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bd24f5ef6f144a0ab5a45056b734d2aa6303a70cb59385f713efe5e1af3c4f4"
    sha256 cellar: :any_skip_relocation, catalina:       "55f6646564abffd81060e9400dec86ec37f5925273629dbabb51ea120122454d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f78714969bb0936c6090987bb750735308e737fd294157a9e2f60f71ad0adb"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

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
