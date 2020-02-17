class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr2.org/"
  url "https://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "cb387dca2bd1e2fb74d7353aaaa9ccf74a958df52f2a852fa520c3ccf43427c5" => :catalina
    sha256 "9be9c82eba1b6b803c75114ed55947692693785566c59dca392b8bbae6b8aa19" => :mojave
    sha256 "8befbeeb644d45a1a8edfebc99035b965dfc95a9d5adfa7227428905168062d4" => :high_sierra
    sha256 "76d763e8d8097435e98239935255d6679e174245b5443f4f87decf4198793444" => :sierra
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
    include.install "lib/cpp/antlr"
    lib.install "lib/cpp/src/libantlr.a"

    (bin/"antlr").write <<~EOS
      #!/bin/sh
      exec "#{Formula["openjdk"].opt_bin}/java" -classpath #{libexec}/antlr.jar antlr.Tool "$@"
    EOS
  end

  test do
    assert_match "ANTLR Parser Generator   Version #{version}",
      shell_output("#{bin}/antlr --help 2>&1")
  end
end
