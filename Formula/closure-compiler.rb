class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20190909/closure-compiler-v20190909.jar"
  sha256 "7bde0e2543e702adec823e95263120697390402e6637888b2d742db9cf9e17ff"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec.children.first, "closure-compiler"
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
