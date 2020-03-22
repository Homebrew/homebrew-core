require "language/haskell"

class Bnfc < Formula
  include Language::Haskell::Cabal

  desc "BNF Converter"
  homepage "https://bnfc.digitalgrammars.com/"
  url "https://github.com/BNFC/bnfc/archive/v2.8.3.tar.gz"
  sha256 "ba0b6ab36954a0891b4ad3125cefdd6d441d2c73d174cd8eff344e68ae2fd203"
  head "https://github.com/BNFC/bnfc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d08ae18737b1354477b232c833f64e2538d5b27f1c5abfa3166cabb8c5e7790f" => :catalina
    sha256 "99468b0d324898ded21ffc6d7605009e0735f5d0b3be2804299916c038c3fa8f" => :mojave
    sha256 "b52608ab271231b3c1ca2aa537793f9988fa4b5a051d5026775a29c1070701d1" => :high_sierra
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "antlr" => :test
  depends_on "openjdk" => :test

  uses_from_macos "make" => [:build, :test]
  uses_from_macos "bison" => :test
  uses_from_macos "flex" => :test

  def install
    cd "source" do
      install_cabal_package :using => ["alex", "happy"]
      doc.install "changelog"
      doc.install "src/BNF.cf" => "BNF.cf"
    end
    cd "docs" do
      system "make", "text", "man", "SPHINXBUILD=#{Formula["sphinx-doc"].bin/"sphinx-build"}"
      cd "_build" do
        doc.install "text" => "manual"
        man1.install "man/bnfc.1" => "bnfc.1"
      end
    end
    doc.install %w[README.md examples]
  end

  test do
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
    (testpath/"test.calc").write "14 * (# Parsing is fun! #) (3 + 2 / 5 - 8)"
    treespace = if build.head?
      " "
    else
      ""
    end
    check_out = <<~EOS

      Parse Successful!

      [Abstract Syntax]
      (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))

      [Linearized Tree]
      14 * (3 + 2 / 5 - 8)#{treespace}

    EOS

    mktemp "c-test" do
      system bin/"bnfc", "-m", "-o.", "--c", testpath/"calc.cf"
      system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out, test_out
    end

    mktemp "cxx-test" do
      system bin/"bnfc", "-m", "-o.", "--cpp", testpath/"calc.cf"
      system "make", "CC=#{ENV.cxx}", "CCFLAGS=#{ENV.cxxflags}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out, test_out
    end

    mktemp "haskell-test" do
      cabal_sandbox do
        cabal_install_tools "alex", "happy"
        system bin/"bnfc", "-m", "-o.", "--haskell", "--ghc", "-d", testpath/"calc.cf"
        system "make"
        test_out = shell_output("./Calc/Test #{testpath/"test.calc"}")
        check_out_hs = <<~EOS
          #{testpath/"test.calc"}

          Parse Successful!

          [Abstract Syntax]

          EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8))

          [Linearized tree]

          14 * (3 + 2 / 5 - 8)
        EOS
        assert_equal check_out_hs, test_out
      end
    end

    mktemp "java-test" do
      ENV.deparallelize # only the Java test needs this
      jdk_dir = Formula["openjdk"].bin
      antlr_bin = Formula["antlr"].bin/"antlr"
      antlr_jar = Dir[Formula["antlr"].prefix/"antlr-*-complete.jar"][0]
      ENV["CLASSPATH"] = ".:#{antlr_jar}"
      system bin/"bnfc", "-m", "-o.", "--java", "--antlr4", testpath/"calc.cf"
      system "make", "JAVAC=#{jdk_dir/"javac"}", "JAVA=#{jdk_dir/"java"}", "LEXER=#{antlr_bin}", "PARSER=#{antlr_bin}"
      test_out = shell_output("#{jdk_dir}/java calc.Test #{testpath}/test.calc")
      space = " "
      check_out_j = <<~EOS

        Parse Succesful!

        [Abstract Syntax]

        (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))#{space}

        [Linearized Tree]

        14 * (3 + 2 / 5 - 8)
      EOS
      assert_equal check_out_j, test_out
    end
  end
end
