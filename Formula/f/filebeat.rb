class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.0",
      revision: "42a721c925857c0d1f4160c977eb5f188e46d425"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1f28b0672ce57aeac3e36761d7653a3b7fe73c23c16d82b0302082d2c79c98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b4c567177eb45619aac68a0b9479a29d5e68d4d8b09ef3312a8aa89fd8f1a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6a40528fef94b5f6dc89a44b1e9db66e26302ac22ea5bb55632e9c90828b072"
    sha256 cellar: :any_skip_relocation, sonoma:        "11f5dc42ee2d7de13979dfb69412e065b8bde396beef808b37f0dc1b00430fd5"
    sha256 cellar: :any_skip_relocation, ventura:       "e2324486fe382b5f7d8d4713d7151048c97b69a1ce8c622a0129b069d7462187"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6451642bdf3f76a1a8d3a70a16522fdc81a8e323c16d6a696a2b8155ca4a76fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc89089c5ebc6daa5cc0eb58365b2695c2c2236798231e960b49b097f973cfc"
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
