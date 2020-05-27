class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20200517/closure-compiler-v20200517.jar"
  sha256 "1a022ae1f31fd1833625fd18951a385ce7ddc27206d22e30b6f24ed48ac12d8c"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"closure-compiler").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec.children.first}" "$@"
    EOS
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
