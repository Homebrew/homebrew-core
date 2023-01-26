class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.1",
      revision: "14f2f8d585f8c380945feee789771bd782cd6b2d"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f19cec475be19d2cf75c802634a59d3a0bf03c1a46f4b594fe42badd16b9c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1346234f8c2ef6ef5ef0dee72d40ed8a2ab742b11b469fac591edc6e1410f827"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe04264aa9835adb910e2e2f6b7bc448f9295faeb734ca2b75ccf3547c8ed4f7"
    sha256 cellar: :any_skip_relocation, ventura:        "dff74cda826f43b08c0d3a756c1a9b1ccb6d01e8f628f95d885064b62790c829"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a36725e2770883f72f5600ccf0dd7554913d1050f2824010757af6803343a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bab6885b50164c4a77c807c78bf3579bb93675f6163c6df44381ce013df9287a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823d4c16d81cd21a5c62fb08a590ac7bc11eef098f21c28322274019324dfd22"
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
