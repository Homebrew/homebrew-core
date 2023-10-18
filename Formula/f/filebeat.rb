class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.4",
      revision: "10b198c985eb95c16405b979c63847881a199aba"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c296820f4c428afc57faad05c0b5d10573500da1bb5710e36acc2681d534e6f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c0c1da0f16a1b27d80ca0115d2fb9ac918abc3ce4e88f879c156ad1166d1d68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "351af5aac7d256e7137ca337d05355852f67089ae9956a37f04d6c4c89d31633"
    sha256 cellar: :any_skip_relocation, sonoma:         "f89426dd0efc78382f54bdb9af0020bf53f76d04118293cd58aee1e89fc98d92"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e3944b48dbf4c83c0637f63061a2927af683e663e17c2ff2f82708f2e5a196"
    sha256 cellar: :any_skip_relocation, monterey:       "3a728ac17708e70e421099d7e4c6fd2309e1e05f0d5d7abe0201c03019f61086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0edd6fad3ceea19f046302b0ed33d60393180a54beae524b1ca0062c9ab710b"
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
