class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr2.org/"
  url "https://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "39b73c18b82c8f0ca76a7245b7b5a9af55da9ac10b8e722cbaafd10febf9e18a" => :catalina
    sha256 "bc4b117c432d2bb29ca76463209ce38d3233ea435ea14666fe76ff8058dda0b8" => :mojave
    sha256 "d8013efcd3b9cf2b53140801125e9b20c6cc10712c80fada68b8fd472e7338d3" => :high_sierra
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
