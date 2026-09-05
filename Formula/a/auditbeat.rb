class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.3",
      revision: "05460763bc6067b3a4708bc80219092eba134988"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa4d8fabcf51d80b88d9b050da2aaab2ba913405efaf9fcf3ba128181c8a398"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65caa9d7106c6bc156af375c65e677e6dc415ce6aee52dbca3974974cad63ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6002cbd597b7aa366c5d53f5c149e7a222ffc933c643c885a66f4f9e3c8fc3f1"
    sha256 cellar: :any,                 arm64_linux:   "de9ac39f8fc85f295469b7dc77bc1fab2fe0cb356aba2d7793f93e4b71f1d1f3"
    sha256 cellar: :any,                 x86_64_linux:  "953ab32b511fe6919bb254dec47d6c1f52e5cd204dfd3ed5ba585d393212edd1"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~SHELL
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    SHELL

    chmod 0555, bin/"auditbeat"
    generate_completions_from_executable(bin/"auditbeat", "completion", shells: [:bash, :zsh])

    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  service do
    run opt_bin/"auditbeat"
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~YAML
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    YAML

    pid = spawn bin/"auditbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"
    sleep 5
    touch testpath/"files/touch"
    sleep 10
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"data/beat.db"

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
