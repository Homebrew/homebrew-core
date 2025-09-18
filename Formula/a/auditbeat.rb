class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.3",
      revision: "d9d2860c7593868e25d1b2da7da43793fe12c99e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ed06cc36915df0d1d78acb5da3d20893234d445157737213633557ede35bc3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b288d3643eb84baaeab7ed7150901b10b901ed30e81b11dbf4fe0d30dba460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76a8e79fb599553064c252fd0932c006b0a20c791e95d3e92644d9a0eee0521"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d2adad86f0fce5e8a716e9ed09efc90bd74deb597880d26fb5ee4bda81614c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "45f42dfd1dfd723c0f9e6006651053293ed04df494198ec6cb6c00100b64917d"
    sha256 cellar: :any_skip_relocation, ventura:       "5f6e8829c4e1560c91eecfb24b0b587f13e5448b7baa0e589eabdf90cbb8fbb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d4bf45cce6f3432e170696ff05b8725fbc9b2040033b264c8b80aedd45ef62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023137df6a8e21618242579152f0e30579b4b3979d609b4cb221662ac7c399d5"
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
