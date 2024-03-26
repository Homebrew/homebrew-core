class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.0",
      revision: "26aad5d437d592cea2d8d3e0b950f885ff47fe41"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6ec8f78d024b36fcdfc7ffccb443c56f26c261a1ce8a266b96b484841edf78d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14d4c363e31f29a8848c0ebb613579af05575fac38e33d1358921d9b03291230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a4ee504e002b910a8a4ac9de11ad9a56ae09199509cacb7a44c716baf4be9aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf48d8856e6ee5f332d82dca18f4062f5b9ee8a97da3ea551255ad7a8d0b362b"
    sha256 cellar: :any_skip_relocation, ventura:        "fffba34db535c1a58cfdbf7bd34253079d268e5983a7b5b2abfb1bd5baaef4fb"
    sha256 cellar: :any_skip_relocation, monterey:       "b599aae70a41454e596d5a9a067f78695c8e4f7c3b018b5ca4bc40981fafc2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72a66416340d7b0d50595faf72fbcfd66cb89243310aeeb22466345d48af95a2"
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
