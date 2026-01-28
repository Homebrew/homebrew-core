class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://github.com/BNFC/bnfc"
  url "https://github.com/BNFC/bnfc/archive/refs/tags/v2.9.6.2.tar.gz"
  sha256 "264c2973752f610d774246e76fb47ac9224ba2cff8498272f00b08411e2b089b"
  license "BSD-3-Clause"
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc1a05687a2bd431e6371fb5068f41ff0bf70648e809111d5453415d194e532e"
    sha256 cellar: :any,                 arm64_sequoia: "2f04ec084ced7d76946370110ff81f016d7ed50292e2a772a706e07a98c20c8b"
    sha256 cellar: :any,                 arm64_sonoma:  "a5148f425a9ce904eb4c861c5563cbf1676f9d87a2d4c85ce029bffbac9e955d"
    sha256 cellar: :any,                 sonoma:        "e955c51e0323aef6c80360cc55765f46f1b3593df94b6044090078749767fd37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0422a1119274343c4a342b076321170f9f987a8dd67f78a6d40c4e0efb391ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f523f3617e9b794c4aa57e752fb7e056adc60b2f48cf436b38692aa5de2904a3"
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
