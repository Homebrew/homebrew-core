class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.0",
      revision: "561a3e1839f1a50ce832e8e114de399b2bee2542"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a162e2364d9cf64f05cca4f17fcdf5f198c9e31cdfe5efd59aee1898e0ca9e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b24ce242847716b83a3619be62f90d389bfe357d966f8606bab36645fe7a29d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "646c572a1ea37368628dc30c5534d44172c8799cb860527f3ae1067297709d9f"
    sha256 cellar: :any_skip_relocation, ventura:        "24329f47087056213dc79e723168eca8fbac2deb962470abbeda7c6b0faa2488"
    sha256 cellar: :any_skip_relocation, monterey:       "c3992be6c0c8a3dab857e8f02fc3d18387dce24bc1b6c0795dc28e531f5ce6c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3103775716f3f99f9c6e47297abaea3351d15d2b39802ba256c3bed55201c841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d2a789ada8b536e581c5db4ac442022951400fcdf0c4b45b0e0780981c8086e"
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
