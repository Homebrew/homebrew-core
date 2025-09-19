class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.4",
      revision: "c50e2cc4adfaed4367b3fba44d27db0222123cec"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a905e5e7f564817085fb5ef6729a1580fb108001cc154887129452bd76dcfc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cae912cdb5cea85c8c99be7624193bd72f37021dfeef35211b99e3075f39a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263581e9611551c930844e78f5c96eb462c50ade2bc14d8c4a6efd0c0173fa9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "59df0ba775869d37bf32cea71a25aeff8b804023fa7b901b155cb0a75cd6e0e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45607f5afa7b7608147855d1cbb1f6a2f0e6ec43ba5a6c7fdf3db83ce73f1d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f0f6ebbf4c018411ffe01d9f7867f99307d6c36e710fc6af5049a1e888fddb0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
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
  end

  def post_install
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
