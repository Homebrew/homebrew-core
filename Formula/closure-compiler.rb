class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20190121/closure-compiler-v20190121.jar"
  sha256 "dc31ccf4b84b37740d3a39c8418914efd6b15807d0451b556fa081289983fa0c"

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
