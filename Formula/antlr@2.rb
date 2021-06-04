class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr2.org/"
  url "https://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"
  license "ANTLR-PD"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "130f56b4182f57e74a535c97948667ff1b1e13bd821562ef573d048676db1e3f"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc27645bb089a3ffc38aeeb4dcc7c5352d93472ac31d7e9853b0b5b90a695e64"
    sha256 cellar: :any_skip_relocation, catalina:      "b3a7378ef4a657176107a37a6d5661b9eb3750f7407ebe081200aa8b45d6d480"
    sha256 cellar: :any_skip_relocation, mojave:        "5642de8d8012c11705b3199f5daf8758d8029333ae9eb4ab113e80069e49ef57"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # C Sharp is explicitly disabled because the antlr configure script will
    # confuse the Chicken Scheme compiler, csc, for a C sharp compiler.
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-csharp"
    system "make"

    libexec.install "antlr.jar"
    rm Dir["lib/cpp/antlr/Makefile*"]
    include.install "lib/cpp/antlr"
    lib.install "lib/cpp/src/libantlr.a"

    (bin/"antlr").write <<~EOS
      #!/bin/sh
      exec "#{Formula["openjdk"].opt_bin}/java" -classpath "#{libexec}/antlr.jar" antlr.Tool "$@"
    EOS
  end

  test do
    assert_match "ANTLR Parser Generator   Version #{version}",
      shell_output("#{bin}/antlr --help 2>&1")
  end
end
