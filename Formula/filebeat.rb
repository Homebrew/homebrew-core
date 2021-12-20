class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.2",
      revision: "3c518f4d17a15dc85bdd68a5a03d5af51d9edd8e"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32abad7c09bae4620b07f0b415dc149bd4f17d42b5369767f38a452af9727eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de7501dda3569502c34dd929433dbdac82bfa7d8367ad5325846317064fb3c73"
    sha256 cellar: :any_skip_relocation, monterey:       "6e9e0ef30633fe9c017efb598a4a2aa0c60c433241b6c58fd46ab812ac5a1cfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "a291a2ae20d0d06fd0ccd2e9db91fdef521ad4edb0eabef7f2a6382b4be3104e"
    sha256 cellar: :any_skip_relocation, catalina:       "76caa22976be332938de4461cf3c23c03075c430e171cf06544a8673669bf29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22ded0242605695db5728b6322f4bf04c62cfb76e4a706d7819f6971131bf59"
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

    assert_predicate testpath/"filebeat", :exist?
  end
end
