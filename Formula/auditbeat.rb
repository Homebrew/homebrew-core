class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5a47a5a8be86676db31130c22c3cea007421a7d7c234b43b017a2fe8d8d3c9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95edebb3721331b411ceeaadfd95c8c258da1228c23bd199df01898ad8bcffc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f38006ad9934cdabe061e095582f9b2a6a79d4f46f721be747ad4da5690b1a12"
    sha256 cellar: :any_skip_relocation, monterey:       "90d2d60e1dc2031e6da3787b49d523c7d26679a4e8594bfb8762ed32132249ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "a64e3f7d2655bb89f458f2ef6174e46bb2ca2962a91f91f0a7fe16d8ebb3b27d"
    sha256 cellar: :any_skip_relocation, catalina:       "391cc69f401d07e3050a73c2facb873f690db2cef380d1022efc34aa19f7afee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01534fe273bf679ae5a1205f2ae8c2274d552e1e403f9a1cd3f024f94f7e0235"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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
