class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.2",
      revision: "480bccf4f0423099bb2c0e672a44c54ecd7a805e"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b02bfbebca08b59bed5eec4f517a5f2578eb91407c8c639aa4747ef909208516"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78debcb5ddd3e87fb71a0a42ad98cd0ac5551002739d63e7763aa8e706c4f2f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce58a6062549c66e1bcf7936f799631098a01cf4272b7aa65c25b050dc4e6fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41cdaed5864fa3977a11298c0b8523e9a3ad596384703904c4cee3727655efb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a79606fa364883eb3228a0838309bfb2fc6216ee13d4a44811fab86683628a15"
    sha256 cellar: :any_skip_relocation, ventura:        "de658ce4b6837ace75ff42db0d5352545a2af4383140eba3749b3ee07dd24c3d"
    sha256 cellar: :any_skip_relocation, monterey:       "50895c2677d1be7a0258a705ef660cd5f5e3135bc46e300ef4f77bc0347da454"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ab999fe893bf0979f8e3bc741d7f92bbb6a03ab0633f71d5e3ec533126a3f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07d13b272ec80652840152b2de37323169702912d124e7c8fe751c7337cc04fb"
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
