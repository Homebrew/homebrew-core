class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.1",
      revision: "53197d5422766e985c2aa0f56607750d34d0e912"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "782752f1256bf8706ce19451846856537d5660395e8a2ba50b4428b1b67e4f11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38adda1593ffa8af4158d10a10cc95c96be132c441b3356cd2db0b8b986f7053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bd75566dc11c2f614832dc5c703ddf4a37e0a4d8faae18f742ed7dc58fabc23"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89ae088a89ab809d6917e00934293b97b40bf93cfc7e767084587a99512f6f6"
    sha256 cellar: :any,                 arm64_linux:   "dbe02710df053d28af36f578defd2450204b53bdda26bc3aaec896fe74e680d2"
    sha256 cellar: :any,                 x86_64_linux:  "d0383ed8da79f77b07132b1b8750b11ff4e20e64b662c55e302c4d98438bb1c4"
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
