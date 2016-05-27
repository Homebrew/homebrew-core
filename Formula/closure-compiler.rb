class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20160517.tar.gz"
  sha256 "6a7ba4c4e991c6325a53f9505b1b2596b36997c4f75d3f34c3a935f5feeb8410"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "70bf10b5959bb354c9418ea4331f609cb7dd2358af66c308e249cacb53868d4f" => :el_capitan
    sha256 "b8f3eeff7682828bb4c1c428aa91ead7f778334f1069856d433332bac4a83c0c" => :yosemite
    sha256 "23e7ec7c81ba1e787137c0b2b94e02b6410f99dc7b460cf26a6111ae4e173f00" => :mavericks
  end

  depends_on :ant => :build
  depends_on :java => "1.7+"

  def install
    system "ant", "clean"
    system "ant"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/compiler.jar", "closure-compiler"
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
