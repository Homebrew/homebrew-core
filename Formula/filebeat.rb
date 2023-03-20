class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0124c1d1ffdc6463ab672b55802887167588c368ab8206c1b4bc9f8dd140aa97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02513f6e6e578f28ef292772bebdc769f77d4ca84dab0efed971b85ce9ffd9f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "513cab44d22e2db4b6e9d0a929894cc76e57fcb3e8f77d763e4f02baceea8e7e"
    sha256 cellar: :any_skip_relocation, ventura:        "fb4fd89aa007711d6eecce7d3f8394cc21fb3ef999fc25b1a75d36d46a5a6eb3"
    sha256 cellar: :any_skip_relocation, monterey:       "45e96f70a4abb93071840840d0328652b7fd1e974fdf38bd66c0247631fe7f76"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e3840a0ec191b20b1198661160d8970ab951286a2cd1c2046bd98dd63007b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2268e58095be87bfa5b46599ca2c05e7841f0db0d7a4778f8ef61da679d560f0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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
