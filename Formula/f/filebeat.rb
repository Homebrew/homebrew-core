class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.2",
      revision: "d41b4978ea7b4d7c6020b47ffd8a3b8642531fe3"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "731613a7e8e1900ecfd209891217c2840586a003a366599cbff4bb239abf657f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b9bdceb0a20fb3695ea086b03d8d9551b69e381ccf58543956b9697d2b6de9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67fc0117b5e3eb23438fc93c6141bf8b91417cc86fe43a7d12586deb8499d2e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "16437e645d6de0e83790a83f1464c8d8d5fbcec3d3c750a52bb4d6b5d64a9e7a"
    sha256 cellar: :any_skip_relocation, ventura:        "96c315af2e265d5bcc0c043c7eff0e8ef0dfce421b5ccf58946bd4cd3164038e"
    sha256 cellar: :any_skip_relocation, monterey:       "ee3eb78dccd6dd4f4635a72b83297b780ef60e1dc800818767fbfe356fd47baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9be092f142b37c86c0404edcfa384e9ab66afd05823f3103efe24ae31950268a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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
