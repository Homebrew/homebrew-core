class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.2",
      revision: "d41b4978ea7b4d7c6020b47ffd8a3b8642531fe3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4344476596d60cf0c57f65b983c502b38b793220dc7ef777e8c79c4dd6dc6d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db722c6244789ef916b5a07eff13716711039c6306b708dd4936d65a05500719"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "213b700b5fc159705ea7975a77bb5a9f3253158aa1ca9febfe2ab70b1e872aee"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a93b2c9aafa1bf15b57db85859bcd0309144502bafef5fd04df96e27e20999e"
    sha256 cellar: :any_skip_relocation, ventura:        "c761698149215475c6e8e0ceb0a1a0e4997c9745926dc137b58618d0eacb3b5f"
    sha256 cellar: :any_skip_relocation, monterey:       "db8129063962d39b23afde5161aa90b41746bf39644758fedb933a1cd7cba5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716463af303ba71298d9509c14a760a929b14e287a95f4e67b1763efa1d15961"
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
