class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.0",
      revision: "a8dbc6c06381f4fe33a5dc23906d63c04c9e2444"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "827c3df92f90a7e5acf76bf0d629555d81b04b9cb51e8163a6258d00242f3cb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a79ef36b226b8112883cb5ec5671b27f949d519d158cb2a61e251821a890e36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f4b48e77e6119b28d6f70bcfe3cf99552480353e56044a5c8e037f8ae02301d"
    sha256 cellar: :any_skip_relocation, ventura:        "7e29149944efabbf71d7fb053af30df67cc895b50ed46b57ace816daab2ca613"
    sha256 cellar: :any_skip_relocation, monterey:       "d896861b8cfa3ccd11d603e47ec49ee738f1a36eded31663e1967f3a7ea795e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "54dbdec3d0a94535141acebe245a09993765a2a73fa8ad75f34f8f770ef704b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fcdb8d94ef836f542178e3b79fd6aa896926c223bf91472539a339e0435b2dc"
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
