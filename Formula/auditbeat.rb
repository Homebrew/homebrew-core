class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.1",
      revision: "6e9dd49b5da9c045125078bb95be9f0dc27e8263"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23d0e93cfd2858fcf1ead2665e70442f3cbdbdf3ca4305ab542699b94279896c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7439dd323da8d5bf1c15287d6ccdc0154a39f09150668f7b3b722769e9dca4e9"
    sha256 cellar: :any_skip_relocation, monterey:       "c3c84c0adcbc100c22012e76ec28cee8ea8604aa329aab099dd4148bc98ca81b"
    sha256 cellar: :any_skip_relocation, big_sur:        "25205460fa0a128c9b753367cdf726c5d9ead9a74bfbbf285c9555aaadecf305"
    sha256 cellar: :any_skip_relocation, catalina:       "dfd55e5e35f16dde39d6978cc6560272df3e9ae93aa3aa99696b171591cb4a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53edf4f977361fb895994680ef644710b8c70895746aa2b59a22ec60eb32a01"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

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
