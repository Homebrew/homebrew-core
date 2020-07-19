class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://bnfc.digitalgrammars.com/"
  url "https://github.com/BNFC/bnfc/archive/v2.8.3.tar.gz"
  sha256 "ba0b6ab36954a0891b4ad3125cefdd6d441d2c73d174cd8eff344e68ae2fd203"
  license "GPL-2.0"
  revision 1
  head "https://github.com/BNFC/bnfc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a56684b9fecdf25ef5c77f9124c8c8c3cdbf5f21405a6135eaf47680c387d231" => :catalina
    sha256 "47cbd943179d46b54c4ff614d613662a4db766ed6f80ec980060acdf6a1c0812" => :mojave
    sha256 "a92f1907cedabddf2a10a994de224cb15221786742beeb1cde87ac47dc17ff76" => :high_sierra
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "antlr" => :test
  depends_on "openjdk" => :test

  uses_from_macos "bison" => :test
  uses_from_macos "flex" => :test

  on_linux do
    depends_on "make" => [:build, :test]
  end

  def install
    cd "source" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
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
    ENV.prepend_create_path "PATH", testpath/"tools-bin"

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
      system "cabal", "v2-update"
      system "cabal", "v2-install",
             "--jobs=#{ENV.make_jobs}", "--max-backjumps=100000",
             "--install-method=copy", "--installdir=#{testpath/"tools-bin"}",
             "alex", "happy"
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
