class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.2",
      revision: "fd322dad6ceafec40c84df4d2a0694ea357d16cc"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "995769d0c414c3217bfbbb4aefe510385e3c891dccada51898a89dd54d7f9e4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bf898722e09ffd7a6b97bf6aa3096397e999778b7d27707b519f62b9fb8c25a"
    sha256 cellar: :any_skip_relocation, monterey:       "db5470cfd68d20a9e505a3d1b75f170d2109fa4ff36747620e54dfde104d87bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdb7fdcccc782cbf48f4d5a7bae1a2e0a513580871b818ec1947706c18264919"
    sha256 cellar: :any_skip_relocation, catalina:       "fd1cc0edc98ed5494a3d89c443991ca1e18f329827530c7e7bd51ab482954fc1"
    sha256 cellar: :any_skip_relocation, mojave:         "150184f53a6f3856ce4b829687741a8e86d84e3b9010083d377a13707f0bab53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75c326473d62c64653a9d3c83ef9055d93d411b69c0500d78cb8d760a9e4a4d"
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
