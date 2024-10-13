class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://bnfc.digitalgrammars.com/"
  url "https://github.com/BNFC/bnfc/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "32a6293b95e10cf1192f348ec79f3c125b52a56350caa4f67087feb3642eef77"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8d9baadeda06fc25d982632ced8e240e3d92d27c3d1668f00334138cdaf527f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5cceadcfc8705ca28116c10045b955c99d9f6d85490fbd4d533691db314c143"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60af864f3a925d506214ea0caeb50df915dae976dfbb320f9adbb8801375c58b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70fbff20aeb4526eee3da488f081c17660bbf390d598190687020cb6a0ebba04"
    sha256 cellar: :any_skip_relocation, sonoma:         "f70febbdc989129871dae2ad9ac254c8a68e137921854a1e9728a301f4bba2f8"
    sha256 cellar: :any_skip_relocation, ventura:        "d645135dfed8bd688b12de81f12c3496d69dc58b1c6c523b48752c44df64cebe"
    sha256 cellar: :any_skip_relocation, monterey:       "efe525933e08206d108405241096da7f5e4b55c00c5cda02fae546b14e94d7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "428910364e4bb5f3fb7f79e578298b97d429b75793ed2dd3c91052209a130e2e"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "agda" => :test
  depends_on "antlr" => :test
  depends_on "bison" => :test
  depends_on "flex" => :test
  depends_on "openjdk" => :test

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
    system "cabal", "v2-update"
    system "cabal", "v2-install",
           "--jobs=#{ENV.make_jobs}", "--max-backjumps=100000",
           "--install-method=copy", "--installdir=#{testpath/"tools-bin"}",
           "alex", "happy"

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

    mktemp "c-test" do
      system bin/"bnfc", "-m", "-o.", "--c", testpath/"calc.cf"
      system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
             "FLEX=#{Formula["flex"].bin/"flex"}",
             "BISON=#{Formula["bison"].bin/"bison"}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out_c, test_out
    end

    mktemp "cxx-test" do
      system bin/"bnfc", "-m", "-o.", "--cpp", testpath/"calc.cf"
      system "make", "CC=#{ENV.cxx}", "CCFLAGS=#{ENV.cxxflags}",
             "FLEX=#{Formula["flex"].bin/"flex"}",
             "BISON=#{Formula["bison"].bin/"bison"}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out_c, test_out
    end

    mktemp "agda-test" do
      system bin/"bnfc", "-m", "-o.", "--haskell", "--text-token",
             "--generic", "--functor", "--agda", "-d", testpath/"calc.cf"
      system "make"
      test_out = shell_output("./Calc/Test #{testpath/"test.calc"}") # Haskell
      assert_equal check_out_hs, test_out
      test_out = shell_output("./Main #{testpath/"test.calc"}") # Agda
      assert_equal check_out_agda, test_out
    end

    ENV.deparallelize do # only the Java test needs this
      mktemp "java-test" do
        jdk_dir = Formula["openjdk"].bin
        antlr_bin = Formula["antlr"].bin/"antlr"
        antlr_jar = Dir[Formula["antlr"].prefix/"antlr-*-complete.jar"][0]
        ENV["CLASSPATH"] = ".:#{antlr_jar}"
        system bin/"bnfc", "-m", "-o.", "--java", "--antlr4", testpath/"calc.cf"
        system "make", "JAVAC=#{jdk_dir/"javac"}", "JAVA=#{jdk_dir/"java"}",
               "LEXER=#{antlr_bin}", "PARSER=#{antlr_bin}"
        test_out = shell_output("#{jdk_dir}/java calc.Test #{testpath}/test.calc")
        assert_equal check_out_java, test_out
      end
    end
  end
end
