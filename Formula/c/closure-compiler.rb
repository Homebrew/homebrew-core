class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20240317/closure-compiler-v20240317.jar"
  sha256 "6b1250ac21c05bdd209dc515d9b6037b30b5555a284dd741ff0591a82848b7ce"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dcc166d1dba7750781c95dd5288aa833273e5a62ebbeb942650a7d49b9db304"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcc166d1dba7750781c95dd5288aa833273e5a62ebbeb942650a7d49b9db304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dcc166d1dba7750781c95dd5288aa833273e5a62ebbeb942650a7d49b9db304"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dcc166d1dba7750781c95dd5288aa833273e5a62ebbeb942650a7d49b9db304"
    sha256 cellar: :any_skip_relocation, ventura:        "3dcc166d1dba7750781c95dd5288aa833273e5a62ebbeb942650a7d49b9db304"
    sha256 cellar: :any_skip_relocation, monterey:       "3dcc166d1dba7750781c95dd5288aa833273e5a62ebbeb942650a7d49b9db304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7977c0a842f26c84383a86cef406c0739429e861f6b3afab9dcd2b0b3dc19c57"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"closure-compiler-v#{version}.jar", "closure-compiler"
  end

  test do
    (testpath/"test.js").write <<~EOS
      (function(){
        var t = true;
        return t;
      })();
    EOS
    system bin/"closure-compiler",
           "--js", testpath/"test.js",
           "--js_output_file", testpath/"out.js"
    assert_equal (testpath/"out.js").read.chomp, "(function(){return!0})();"
  end
end
