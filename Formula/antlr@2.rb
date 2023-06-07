class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr2.org/"
  url "https://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"
  license "ANTLR-PD"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc327766c4c3b41d68077db70b1f0c21f9f623c0e38f0998715e3267bb1ba492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26acb924f40645e50255ac11d6cd9ad1d6153c80ee089e5f758a093eae2432d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "130f56b4182f57e74a535c97948667ff1b1e13bd821562ef573d048676db1e3f"
    sha256 cellar: :any_skip_relocation, ventura:        "bb362869f146659bd19dde3d4145d8cc3514e65bdb2c3271765766f51080dc4d"
    sha256 cellar: :any_skip_relocation, monterey:       "5284f23a92d24e07f5e13a7564904b44b43b82552db78bb761bdad8e23b1118e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc27645bb089a3ffc38aeeb4dcc7c5352d93472ac31d7e9853b0b5b90a695e64"
    sha256 cellar: :any_skip_relocation, catalina:       "b3a7378ef4a657176107a37a6d5661b9eb3750f7407ebe081200aa8b45d6d480"
    sha256 cellar: :any_skip_relocation, mojave:         "5642de8d8012c11705b3199f5daf8758d8029333ae9eb4ab113e80069e49ef57"
  end

  keg_only :versioned_formula

  # ANTLR4 is the actively maintained successor provided by the `antlr` formula.
  deprecate! date: "2022-06-20", because: :deprecated_upstream

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
