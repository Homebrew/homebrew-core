class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://github.com/BNFC/bnfc"
  url "https://github.com/BNFC/bnfc/archive/refs/tags/v2.9.6.3.tar.gz"
  sha256 "f8d7356adcf8f068e6ae253402623cec0f19f1554c341f7346687a9654f5e109"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/BNFC/bnfc.git", branch: "master"

  bottle do
    manifest_sha256 "8c5c0552a52c94cd305fa3ea3e4585953ab2c1e29e09fb7f9072012ab71903d0"
    sha256 cellar: :any, arm64_golden_gate: "6fd85907cb50f3463bf13fa3d8bdddc929c01ebee99371444f880c48bd9e773c"
    sha256 cellar: :any, arm64_tahoe:       "f14747d259ec8e3859ccfa58b2eaf863fc3b9a862a41c0d207aa28f0221e8b75"
    sha256 cellar: :any, arm64_sequoia:     "01ddae81af55eaf4ab355e5fc8935b2a72c57d4ff506957cbc915323c5f131bf"
    sha256 cellar: :any, arm64_linux:       "35842bb24671fe0c339ec591086de0f6e27513fc14ab43b82a0a3e9c02b94284"
    sha256 cellar: :any, x86_64_linux:      "f8a9ecaa4511f9ba879b97926ab826c04c2a8daa62d3e280ad08c46bfb38d185"
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

  # Keep Flex buffer types private to generated scanners.
  patch do
    url "https://github.com/BNFC/bnfc/commit/00b6d08901f11d4e3a407ecabb2626e6025f763d.patch?full_index=1"
    sha256 "db02606640140364851f0ae061181ca0921b8da569f3e1eb050f1be0e9cb81eb"
    type :unofficial
    resolves "https://github.com/BNFC/bnfc/pull/576"
  end

  allow_network_access! :test

  def fetch
    rm "cabal.project" # avoid resolving test dependencies
    cd "source" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", "--only-download", *std_cabal_v2_args
    end
  end

  def install
    cd "source" do
      system "cabal", "v2-install", *std_cabal_v2_args
    end
    system "make", "-C", "docs", "text", "man", "SPHINXBUILD=#{formula_opt_bin("sphinx-doc")}/sphinx-build"

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
      #{testpath}/test.calc

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

    flex_bison_args = ["FLEX=#{formula_opt_bin("flex")}/flex", "BISON=#{formula_opt_bin("bison")}/bison"]

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
      # The Haskell and Agda targets race to compile the same modules
      system "make", "-j1"
      assert_equal check_out_hs, shell_output("./Calc/Test #{testpath}/test.calc") # Haskell
      assert_equal check_out_agda, shell_output("./Main #{testpath}/test.calc") # Agda
    end

    ENV.deparallelize do # only the Java test needs this
      mkdir "java-test" do
        jdk_dir = formula_opt_bin("openjdk")
        antlr_bin = formula_opt_bin("antlr")/"antlr"
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
