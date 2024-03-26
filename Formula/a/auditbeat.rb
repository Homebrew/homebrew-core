class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.0",
      revision: "26aad5d437d592cea2d8d3e0b950f885ff47fe41"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d03ef1ec632a7a7fa6cd583af2723da0931b28c7a9e4817cce84134fc1a84f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b96a4b6337371e56b7e677e0c577398d4f8f85f917d706cb8c7ae5cc7dcb72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8c0c4cdd900c098247cc5e6067fb999be3979ddfc8dbad24f8bb748e1b8305"
    sha256 cellar: :any_skip_relocation, sonoma:         "76578515b6df08356e1277dd13647c89f52c9df4c6e9e89fa81a5abdcc1e4a75"
    sha256 cellar: :any_skip_relocation, ventura:        "4ecb684fde537157dd727eed7ec9bde12217e4997c62b6d138bbb670124f56b9"
    sha256 cellar: :any_skip_relocation, monterey:       "58b918a1d5bb889ca52ca1c2662651a9fed913d602159c1a29b05bf83416aab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff68385d8ea4ae371687bc6c997f75d7368526320c91679d797a4f57154385a2"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    EOS

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
    (testpath/"config/auditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    EOS
    fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5
    touch testpath/"files/touch"

    sleep 30

    assert_predicate testpath/"data/beat.db", :exist?

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  end
end
