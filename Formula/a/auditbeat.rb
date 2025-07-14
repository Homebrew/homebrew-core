class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.3",
      revision: "c394cb8e6470384d0c93b85f96c281dd6ec6592a"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e05450172bf0c1d1c8709d1ee1fbf73c84abe0e3cc2a648688e6993d6d9b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85d9a52c5b14679d86376bbec954de1c86af04c0715fc7c66576176c0ab0f85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64b9c418a0b1b738a32216ed145d1476f3deff01b39d45511dcdaa80f54fc794"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eaf90491661a4678bc4bb6b63ae84a734a40b9ac12e8bcf0302aee4d1d64acf"
    sha256 cellar: :any_skip_relocation, ventura:       "3899c540177ae0015378ee73ce2a3a27735736d67e50f98126843e2f264dad8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "946296ef9bba943cda66cc2e0ddc58aa76d43508f21ad07d034c35f10d214d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7673076a19bb6cd396d0d0078d622d69a39e98f3aea0f0ddaa0176e36618080"
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
