class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.4",
      revision: "45b2d3821c3ff0da055e025ec16a126c27423462"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30db2e43e62a984ee65125c37a527e9d75d1037deecca7d10a79136a14de69cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e71e94ffe724f0b1379c828137553b9d266465129a345682d373126c37f6c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db2f120aa3bca8807bdff2f05c253e405c16881e4aad2888dd2a89b423c22542"
    sha256 cellar: :any_skip_relocation, sonoma:        "841be69e3e39df86b2036c1b2181406979120c8b5399b7ca188688496a6dcb88"
    sha256 cellar: :any,                 arm64_linux:   "a7e40d0c6c1f65f4ed96bd7378cc65e4102f08619bf2184518c036d1690c8db1"
    sha256 cellar: :any,                 x86_64_linux:  "14a4b2a7dc30e3962ddc8c4cb8cb719c03411898cdd352b035c3a565d051a9dd"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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

    (bin/"filebeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/filebeat \
        --path.config #{etc}/filebeat \
        --path.data #{var}/lib/filebeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/filebeat \
        "$@"
    SH

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

    pid = spawn bin/"filebeat", "-c", testpath/"filebeat.yml",
                                "--path.config", testpath/"filebeat",
                                "--path.home=#{testpath}",
                                "--path.logs", testpath/"log",
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
