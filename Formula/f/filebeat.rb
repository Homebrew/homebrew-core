class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.1",
      revision: "c74896ed7acbb92921ee46fa5e3d66d575a8b0a9"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a786113d55ef2db57b2e3cb98500a406885023b1e97a20af31965cf08fa2b154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e165e2b8b619422795d13995b6bee1b74822526243c8d5d42e25b96cd022d43d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "817024010572e92fc309fa0a0a4d831a119acc0838708f04c69efaed87a0e9c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb9e8da6169e029d1ba98b5571ead06ae175931dd3dc49fe09586aed3ad3de55"
    sha256 cellar: :any_skip_relocation, ventura:        "afcd3144eb7a93e2f2c34e67d85d25fff32463123b43d749fcc20232cc52780a"
    sha256 cellar: :any_skip_relocation, monterey:       "9db6f78fa4f137016caf59b99d77c4cc71c968002d0ca710e55c98a19581633c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54e550f72b377a662f4159fb5f688651eaaa4838103aaa80d2f6f557043aeb09"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, GenerateModuleIncludeListGo, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, GenerateModuleIncludeListGo,"

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

    chmod 0555, bin/"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"filebeat", "completion", shells: [:bash, :zsh])
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

    assert_predicate testpath/"meta.json", :exist?
    assert_predicate testpath/"registry/filebeat", :exist?
  end
end
