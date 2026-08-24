class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://github.com/BNFC/bnfc"
  url "https://github.com/BNFC/bnfc/archive/refs/tags/v2.9.6.3.tar.gz"
  sha256 "f8d7356adcf8f068e6ae253402623cec0f19f1554c341f7346687a9654f5e109"
  license "BSD-3-Clause"
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "41cffb2aee5f15d22dcebd7968fd8f3e7563a68fd4ccf8bbb4635acbe4adbea8"
    sha256 cellar: :any, arm64_sequoia: "f17851a8eca236629d4303ec1a8bd7cfc643026afc4693b2a6e4ea4573cd018a"
    sha256 cellar: :any, arm64_sonoma:  "c2fc22b15b39397d8eb318ae5f3dfb8edec8efed2d7ae3674c19db1db6afe083"
    sha256 cellar: :any, sonoma:        "441cd6a734fdc327d823775e99bc4f5f12c053c320022e62bad2821866f8c0ba"
    sha256 cellar: :any, arm64_linux:   "6dc5937b968e78dba9fc4e575f2b9e6585982c1d1793f44daa6588293fb49721"
    sha256 cellar: :any, x86_64_linux:  "b712c8728db628fccd32c4c20e6e3d6ca598fe005457444a9db33e955e4df6b7"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "agda" => :test
  depends_on "antlr" => :test
  depends_on "bison" => :test
  depends_on "flex" => :test
  depends_on "openjdk" => :test
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    rm "cabal.project" # avoid resolving test dependencies
    cd "source" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
    end
    system "make", "-C", "docs", "text", "man", "SPHINXBUILD=#{Formula["sphinx-doc"].bin}/sphinx-build"

    man1.install "docs/_build/man/bnfc.1"
    doc.install "docs/_build/text" => "manual"
    doc.install "README.md", "examples", "source/CHANGELOG.md", "source/src/BNFC.cf"
  end

  test do
    ENV.prepend_create_path "PATH", testpath/"tools-bin"
    system "cabal", "v2-update"
    system "cabal", "v2-install", "alex", "happy", *std_cabal_v2_args.map { |s| s.sub bin, testpath/"tools-bin" }

    (testpath/"calc.cf").write <<~EOS
      EAdd. Exp  ::= Exp  "+" Exp1 ;
      ESub. Exp  ::= Exp  "-" Exp1 ;
      EMul. Exp1 ::= Exp1 "*" Exp2 ;
      EDiv. Exp1 ::= Exp1 "/" Exp2 ;
      EInt. Exp2 ::= Integer ;
      coercions Exp 2 ;
      entrypoints Exp ;
      comment "(#" "#)" ;
    EOS
    system bin/"bnfc", "--check", testpath/"calc.cf"

    (testpath/"test.calc").write "14 * (# Parsing is fun! #) (3 + 2 / 5 - 8)"
    space = " "
    check_out_c = <<~EOS

      Parse Successful!

      [Abstract Syntax]
      (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))

      [Linearized Tree]
      14 * (3 + 2 / 5 - 8)#{space}

    EOS
    check_out_hs = <<~EOS
      #{testpath/"test.calc"}

      Parse Successful!

      [Abstract Syntax]

      EMul (Just (1,1)) (EInt (Just (1,1)) 14) (ESub (Just (1,29)) (EAdd (Just (1,29)) (EInt (Just (1,29)) 3) (EDiv (Just (1,33)) (EInt (Just (1,33)) 2) (EInt (Just (1,37)) 5))) (EInt (Just (1,41)) 8))

      [Linearized tree]

      14 * (3 + 2 / 5 - 8)
    EOS
    check_out_agda = <<~EOS
      PARSE SUCCESSFUL

      14 * (3 + 2 / 5 - 8)
    EOS
    check_out_java = <<~EOS

      Parse Successful!

      [Abstract Syntax]

      (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))#{space}

      [Linearized Tree]

      14 * (3 + 2 / 5 - 8)
    EOS

    flex_bison_args = ["FLEX=#{Formula["flex"].bin}/flex", "BISON=#{Formula["bison"].bin}/bison"]

    mkdir "c-test" do
      system bin/"bnfc", "-m", "-o.", "--c", testpath/"calc.cf"
      system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}", *flex_bison_args
      assert_equal check_out_c, shell_output("./Testcalc #{testpath}/test.calc")
    end

    mkdir "cxx-test" do
      system bin/"bnfc", "-m", "-o.", "--cpp", testpath/"calc.cf"
      system "make", "CC=#{ENV.cxx}", "CCFLAGS=#{ENV.cxxflags}", *flex_bison_args
      assert_equal check_out_c, shell_output("./Testcalc #{testpath}/test.calc")
    end

    mkdir "agda-test" do
      system bin/"bnfc", "-m", "-o.", "--haskell", "--text-token",
             "--generic", "--functor", "--agda", "-d", testpath/"calc.cf"
      system "make"
      assert_equal check_out_hs, shell_output("./Calc/Test #{testpath}/test.calc") # Haskell
      assert_equal check_out_agda, shell_output("./Main #{testpath}/test.calc") # Agda
    end

    ENV.deparallelize do # only the Java test needs this
      mkdir "java-test" do
        jdk_dir = Formula["openjdk"].bin
        antlr_bin = Formula["antlr"].bin/"antlr"
        antlr_jar = Formula["antlr"].prefix.glob("antlr-*-complete.jar").first
        ENV["CLASSPATH"] = ".:#{antlr_jar}"
        system bin/"bnfc", "-m", "-o.", "--java", "--antlr4", testpath/"calc.cf"
        system "make", "JAVAC=#{jdk_dir}/javac", "JAVA=#{jdk_dir}/java",
               "LEXER=#{antlr_bin}", "PARSER=#{antlr_bin}"
        assert_equal check_out_java, shell_output("#{jdk_dir}/java calc.Test #{testpath}/test.calc")
      end
    end
  end
end
