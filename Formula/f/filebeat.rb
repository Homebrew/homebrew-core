class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.1",
      revision: "bce373f7dcd56a5575ad2c0ec40159722607e801"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9354e49ba222f0b29850a34cdb38b270af914ebf22a611b388e28932fe44ab94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1812d1ef0748b60a940a308c1233bb569f7f677cee36f0a1edea3899dd2c73e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e4da494a066fbf21e8294144e566fa7afa08e57b757bf202e12799bafd6d796"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c2cadf9892d239c3ead50a273d20ebd8af47f133f9d427c5503f955ae3d36aa"
    sha256 cellar: :any_skip_relocation, ventura:       "b64dc7728add30d5223482289d0009d73430ea8fdb210aff56e10ef6566c319a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9b694ccaeb89db671019d43447a27c508f0f332708d8f95c6e3f5a7dade1208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f84e92b8a061cfdca7d9cb8640aa58377c6cec7961036ef89fd1ca0579eee6f0"
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
