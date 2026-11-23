class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.7",
      revision: "9455ccba703306aae4ed36b86a03976c963c0186"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    manifest_sha256 "c0c5a0deab9efc9587962c5dbd58fa9ecd70c2aca3985cef608c6f77e586dc4e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fe48766a390bc16dcbe7ec7bd28321f97531e79ed46ddac222ec2c10424b6da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ab5cc999964091d6f6b4708b3103f55b78cb41e9b2c485c3b0259872da3d48b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c70561ff4f2aad838e0a2fe9a8ecbe63975229904f6faecbf2fdcaef3b94e1df"
    sha256 cellar: :any,                 arm64_linux:       "c442e5f3b86e9ad56d40cbb023cfd153cc10d85d6bec4bd16e103cfcd952c24d"
    sha256 cellar: :any,                 x86_64_linux:      "9e8d2ebb5422a3a4b9fc871b45ed736ecd8616eb63ea3658471e1992beef019b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

    with_test_process(bin/"filebeat", "-c", testpath/"filebeat.yml",
                      "--path.config", testpath/"filebeat",
                      "--path.home=#{testpath}",
                      "--path.logs", testpath/"log",
                      "--path.data", testpath) do
      sleep 1
      log_file.append_lines "foo bar baz"
      sleep 5

      assert_path_exists testpath/"meta.json"
      assert_path_exists testpath/"registry/filebeat"
    end
  end
end
