class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.12.1",
      revision: "651a2ad1225f3d4420a22eba847de385b71f711d"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fa194fe1b211cc45f06997777ec27c0158ac220d0166f8a424d9dcefe5810a4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e9b93996330664d7db6eb47cc60b3eeb888442106cb3f8d482506d01bbd43fe"
    sha256 cellar: :any_skip_relocation, catalina:      "a1c421d2750ec1af7b1bf894e196d78c0faa989462c37f04098ea8bdd7b7d443"
    sha256 cellar: :any_skip_relocation, mojave:        "fcf45b1eed0a0f57fc061ff77853c8e6010cd6e6275bd1063e96c928ba9045e6"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.9" => :build

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

  plist_options manual: "filebeat"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{opt_bin}/filebeat</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
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
