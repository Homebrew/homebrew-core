class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.2",
      revision: "8f4fe1e5dec067a139dce33d3af88c24b58c3660"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ea05f6e84980ec49e9491d946b944ffc4dd659551d36b865b9c62d3c09c205c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "379e2656159869b0ed5f8b19049e30bd029375f1d497c76488d93231d9753e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674f954152d8bf7ea3b13b24eb3cb676ae35ae88185aa7d8d5252a083850eb82"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e15edf47393b824400b6051bb797b48097b8abceaa24b4f09dc00b55f5df41"
    sha256 cellar: :any,                 arm64_linux:   "40353b74c2bf25ec9d076320adc5fe0b3d0979a05b99b0f6ab46b6bdd9189350"
    sha256 cellar: :any,                 x86_64_linux:  "e377d9a8937b7ca6b70db07954f6ff65a83fcdf217b739100de9e46b2c034000"
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
