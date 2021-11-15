class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://bnfc.digitalgrammars.com/"
  url "https://github.com/BNFC/bnfc/archive/v2.9.1.tar.gz"
  sha256 "d79125168636fdcf0acd64a9b83ea620c311b16dcada0848d8a577aa8aeddec4"
  license "BSD-3-Clause"
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecadd82438160dd4d36fcc6a10a1f88b0caf9695142770a4986e9616300964a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "582a5d263f6ac1420e1f4a749fdefad35aad9bbf960f97f57a1c16dfd1c29e4e"
    sha256 cellar: :any_skip_relocation, monterey:       "66b6637f6e3b968e152f3b84e4ddbe50fc6d8a7bba3ce9f5e3d51ef87a16c8f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f3c56a6f814bc0625000b7341ffdb6e6b9fbc60f9e9bef4819214e836b9abd8"
    sha256 cellar: :any_skip_relocation, catalina:       "33421a59619bb8911362221d25dc6b4b857be514a63795df2ea0bd297eb5bc8a"
    sha256 cellar: :any_skip_relocation, mojave:         "dced427e3ffcc7bdffe354025d2e19d45f31c87e8e687d243cd1505108dadc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3716b9a49f6a62197755414097a0af56ffe4bfda0a2fbbf898ea4d921af1b534"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "antlr" => :test
  depends_on "openjdk" => :test

  uses_from_macos "bison" => :test
  uses_from_macos "flex" => :test

  def install
    cd "source" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
      doc.install "CHANGELOG.md"
      doc.install "src/BNFC.cf" => "BNFC.cf"
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
      14 * (3 + 2 / 5 - 8) #{treespace}

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
