class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20170409/closure-compiler-v20170409.jar"
  sha256 "23f2ec52dd09fd5d5614ae6f6b93667bfe4526cbc281e04277e53b8888763548"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec.children.first, "closure-compiler"
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
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
