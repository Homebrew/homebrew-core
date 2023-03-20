class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8841c3c3bf575865a50c0cc19b983035622bb5ef538436f7092cb3eca0051ee3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ae08c355bdac71f654a2f2537ff996f1ec1e190a3e2d01421859001071a7f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40a685929aaf9800c52375e672bc0b3169a76936f69728d0819a7fdf00de5b53"
    sha256 cellar: :any_skip_relocation, ventura:        "986175254973672f1c09e4b1d682c126932ca64c0d1e04495b7b1348208a46f0"
    sha256 cellar: :any_skip_relocation, monterey:       "572e7eca1fb61d6e4342daca2db1ea6aaf6f461df853cc5a8aab91a56f72479e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eab463e32e70253b8b92991e858895d1a849d09a03e6ad3ac1a6a49dafc1546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2173f18b616f9275f696b71d5a29eaa3e987b627c9f14f946bea072ee8447e"
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
