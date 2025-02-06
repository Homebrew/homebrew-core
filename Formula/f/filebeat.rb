class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.1",
      revision: "424070e87d831d2d66a7514e1c1120ad540a86db"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "236a68c1f4302c6f97273d2b75cb5c9fd07c551aaaa75dd336f61ec22c81b17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e989612d09eec8c02f7bf5c54408656a35f79f6522587b1668d5db6e4fcd6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "944eb5cdcaf2af14cd53bbc8bddc838aca9b7f8b6f84d20d0863f9128a62c6f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e2d731c577f07e6db43c1f0fd73b4158e1fb5610f7020140489c59475e5d6be"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b0d9a6d1d2a9b6650c6fac0935cf8d86863959e2a442c0233a52f9ad8354a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "213b410e7306a4a33c1429b1b499dc66fdf7f69ceb58fcb40d2c039f76753cb0"
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

    assert_predicate testpath/"meta.json", :exist?
    assert_predicate testpath/"registry/filebeat", :exist?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
