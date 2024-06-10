class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.0",
      revision: "de52d1434ea3dff96953a59a18d44e456a98bd2f"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ba79c65e194d1a912836d9838c0f70dbadad3cfea824a84cb7a4c0f30a2111e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe880afc499023b56a48bd5559b27a01babfb8dc092ba3d19657c1df7e4c4c77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e4ebcd48297e5cb77d0883137cf95589d6b6ac0b874d652cdc7a720fb113e80"
    sha256 cellar: :any_skip_relocation, sonoma:         "37bd3d9bb339416136914252cd5c9d3f55f62f81c8c85dc20ed1d243d68f69b0"
    sha256 cellar: :any_skip_relocation, ventura:        "4db565cb6466f33ef7dee20d4df67dc6945913bd5c79eebe742c9ce9471ea186"
    sha256 cellar: :any_skip_relocation, monterey:       "cf78f584d8e956ea47b478946239aa8d460e1fe485650c116cbf4e204276101b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27bfa84af0778b6a2cff682adf4d921fb3e48baf717ddb536df14cbb8cdc73c9"
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
