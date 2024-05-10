class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.3",
      revision: "79b1528b7bfbf5152041db8f4ab497af6afa06e2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b632d746f0ebbcf0187649fd06c13a7b14e0c238ab6d4d27f1f50d2793b2992"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8e18b666e14ad994a214392d6a4d7beeaca12775a0951f630cc04197a76e34c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21c0b1e4ee58fd495066e660cbe8981833f7c64198a2fb957ae3e763d6fdbd3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e45a7146f07235100c4747bade2707c38ac42bfe34bde9379f0cf15fcc4c4f0"
    sha256 cellar: :any_skip_relocation, ventura:        "980bbfe7beec6407a872506c3b4af21f6e16da3aef7e09bf62a1df401e5b552b"
    sha256 cellar: :any_skip_relocation, monterey:       "15850295c5b1366feff455feadcc15d00894a3ab024a6b6a125775334b00a4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d062553909fe3d12956e4a97659fe3f0a51a04a6a543c4d9b58aebd285d2a14"
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
