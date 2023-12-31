class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.3",
      revision: "bfdd9fb0a3c4eeeacf5a5bc2110164a177e4cb08"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b0513f26084dab9ea15a82d30d0c9fc928d54375f2165caff2caabf6d87b01c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04fc1f28c837a8fc33edb13bf478fab04728892fe449a56008525f0107e0857d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2d9e54e03aee2d1ccf340ca7df60bb641bc4b35777216d0716dc7f669e022b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2eec478d8623fcfee9555db13039ee2d255759b1bf5f92b30c8278302b35cc72"
    sha256 cellar: :any_skip_relocation, ventura:        "54ae1ae2c1f750e6a1c9fac442380c120cef53bdc3a26f23dfc1b0cf052059ab"
    sha256 cellar: :any_skip_relocation, monterey:       "43a393af7fd00b0a4be9864690586000ce8f187bed95f2cc58cff284dde21af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1ed9457c94866735ca6ae2614a2099e20cc072ceea66adf336653808c7fb555"
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
