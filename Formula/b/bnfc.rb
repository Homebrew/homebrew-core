class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://github.com/BNFC/bnfc"
  url "https://github.com/BNFC/bnfc/archive/refs/tags/v2.9.6.1.tar.gz"
  sha256 "da787f1a4cdb2476b7fbeb91e13ae831850c47261a14eaba0051aadbe75b1cc5"
  license "BSD-3-Clause"
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4527a1670a78475c265fc33d67b1c94ea25a589c476d1ac460dcfcfe42a20d3"
    sha256 cellar: :any,                 arm64_sequoia: "c31434982bdab1d316d2d79f1d8099b3ac6f3594b5cb7f1c4e44dc8647915d24"
    sha256 cellar: :any,                 arm64_sonoma:  "1ba668bdd79f0631df24fc241d90a491886e4126123d070570609e6e4d4b0af8"
    sha256 cellar: :any,                 arm64_ventura: "16570619aab4070fa4d4517dc650d53fa619d95f3e14fe1f0b46914d9079c8cc"
    sha256 cellar: :any,                 sonoma:        "f24d3c0ff480f926217d9fe826760c6ab59b8ec6100f6c3e9d329da3100b8386"
    sha256 cellar: :any,                 ventura:       "7ac68aa426aaca6251a69e6ad730ec582d2d6ae127b2d80f68c1c3aedba6df71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79f089fe534748760af745ceebf7510828153f6f7e1bc898387480fed6aded1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b36466a041cf9cbbd8aadd038903c7f02a1a98873c61990ce4dd16615a9ebab"
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
    system "cabal", "v2-update"
    system "cabal", "v2-install", buildpath/"source", *std_cabal_v2_args
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
