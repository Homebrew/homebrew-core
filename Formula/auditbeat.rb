class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.3",
      revision: "c2f2aba479653563dbaabefe0f86f5579708ec94"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bceab099ebc40f3ab6be6954f7e4ce1f372b871ab9a2f589a48ca9fe32bab4ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d687105c2ce3d00ffd5d5e7ff51aaf07d18e12c461a0dec5683f8b1e68929b9"
    sha256 cellar: :any_skip_relocation, monterey:       "3b7fe97ddc5a49f3e31b8ef2933bb6691a4eec9e47b179ee6ebf2835001d0222"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc72ee9ca9ef2347ef329069c191aafec0708d0c35088f9885827c5f7ce155a1"
    sha256 cellar: :any_skip_relocation, catalina:       "09fcf5fea1cd21376fd03ef67e715e40c2edc2a15bfbb368707c1e88761482d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e96fff5e5408f29acda79c8dd69ed5ce605c293457d0c472303f873b75b91bd"
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
