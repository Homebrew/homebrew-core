class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.0",
      revision: "de52d1434ea3dff96953a59a18d44e456a98bd2f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "121bd14d49b094f676e3b8082d76f74cea13f5b3a03dee8df1a8772a5e7de665"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c95b5d6b2a5df120b0e3bbc2f699c39a8316f8847e29367b312620df885a8c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebb298120aa1448c04657d4505e0cfedf22f5b26f3f332b259f2df98eb8e9c8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ac4d6f89aaf77a35af62df5de5e8145ceea92cf7df5fcfc2ecc94c2d1db1a4b"
    sha256 cellar: :any_skip_relocation, ventura:        "0d6b5ffdbe91ee03699b20f0da8ff30c9292f63c35a6aabf390095c1194c32f3"
    sha256 cellar: :any_skip_relocation, monterey:       "103d0458a26c34fb7c8393d352b637ad6298cffdf298e2640c83ea1459ee9b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1eef69889baf4aa6240d9dfcfb5bb91f86e4571508b1fb7f19d58e5440f4e4"
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
