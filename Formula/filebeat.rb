class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7435eb1e6ef3c58f33cddd92629c78a226b79218ecac374bd3a8cd8ccabe02eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afaa64dba59611b95d78a72a2409a78f699bb014c1ea2177029f64e6339bcef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdeeef20c7be1b693c5092ca9dec6d56f5b028b5c710623e31228cb83e5d4283"
    sha256 cellar: :any_skip_relocation, ventura:        "2028d099d35787791c76f94329e76f9616f0deb31e1bb0caafba4cb3715d15fa"
    sha256 cellar: :any_skip_relocation, monterey:       "728da40d4ac0e5e1078f075e1560eb514f808d731a9627a445bedf1993e08909"
    sha256 cellar: :any_skip_relocation, big_sur:        "db5a92b0d6c0fccea25ce89955e7eef309300b2d0495a5b532ac0ffc31aa962e"
    sha256 cellar: :any_skip_relocation, catalina:       "8e05ae4b8ec4c7e71767c66392f71cbd650eb1d43a134fb06a6e03b73830f2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47ae23ee22904fba9a8d2733d4cbc81bef77e89c5e710247ff53825a0f7055b8"
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
