class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.0",
      revision: "561a3e1839f1a50ce832e8e114de399b2bee2542"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75f354e40cb2f2ecdae2610be3d8d8745025440cdff4db190dc6a83c566ccbd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83e6771ab12f7fd8627ea221e1f5d15a9e52e9ba2ea46a744debeed3bc95e8d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "008853425bdf9a529f9b851f4511ae9e2450bb821e3194a1f87df9bc001e385d"
    sha256 cellar: :any_skip_relocation, ventura:        "aa792d4263408ddc6c3caa4819e1087ad3fa0a2632831662ee050050c1dcfab1"
    sha256 cellar: :any_skip_relocation, monterey:       "82040946801e7a2751188032175744e0c15a93a8897dc6502f86665e528be1e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c79488b6cba9b78bce67bfd34f0b542ea25ff6d037e895f2a93052e1a39e49f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecdc20064b5a11712b45610601113aeb1cc206fecf2671f903b5ba09805fb4aa"
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
