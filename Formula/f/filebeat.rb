class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.3",
      revision: "d9d2860c7593868e25d1b2da7da43793fe12c99e"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b989dc2bb07ff0725039ece5321b48666bd89a837a48ab7a5b36b473d164fef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6ed02081ef9ee34cf24cf9dd2527e655c12c5ed673f9642840d07e2293db871"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ac8038d82064a3c0a34f50e805751ad3b771a13b3c7c62e554302d2ff7999d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0bcd9276349907cc88b532b6b62d7ec7ed6cea7caee0849566c6cc8bc619da6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ef010a1244e8f900a01235e5b70fa582a4246e4f5fecf6f0728b5527ef11d35"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c44f3fc11c6081bfd3ca61f9a7295fa8e511637da908a1fd1e7885fa7d29ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a75979d3459e7e465a9a2dbada8385fd7f61fde43feb91013805e06752650db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d214bd7d9568f5b5c7ea75468c4b82c3bfd48cd105a529d09a4be04b5deb457"
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
