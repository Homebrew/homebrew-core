class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.3",
      revision: "c394cb8e6470384d0c93b85f96c281dd6ec6592a"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1db04d20f77313f87714c3955a614f46713aff8a57bbd6e1949ae1660f0b4b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dccb866f2ccdb4415ee7ccd19f5b2f240c28cb7ac152681e44b3b5d1bb62d850"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d76cdb3d7e8aec2e2f47c2c7ad017d133781b2b5c7ad30c26ba4ea6285985649"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fb2484d9f4ac50ec4dc740cadab161cdaf18d3b9698b023b2b6d9c2c216e158"
    sha256 cellar: :any_skip_relocation, ventura:       "ed4d94419f8d753d96933d133b8783a6c02ae48855995bd78dc09cb03d45321c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a319fbaa57c0015421eb674b001fc350799c848d9c54547493573592b9fc719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b5df44a3a0ee2a4742283c25c307aa4b473054ccee9314c0745bcb66039316"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", /GenerateModuleIncludeListGo, fieldDocs,\s*filebeat\.CollectDocs,/,
                               "GenerateModuleIncludeListGo,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["filebeat.*"], "fields.yml", "modules.d"
      (pkgetc/"module").install Dir["build/package/modules/*"]
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

    (testpath/"filebeat.yml").write <<~YAML
      filebeat:
        inputs:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      output:
        file:
          path: #{testpath}
    YAML

    (testpath/"log").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"filebeat", "-c", "#{testpath}/filebeat.yml",
                                "--path.config", "#{testpath}/filebeat",
                                "--path.home=#{testpath}",
                                "--path.logs", "#{testpath}/log",
                                "--path.data", testpath

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_path_exists testpath/"meta.json"
    assert_path_exists testpath/"registry/filebeat"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
