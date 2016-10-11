class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20160517.tar.gz"
  sha256 "6a7ba4c4e991c6325a53f9505b1b2596b36997c4f75d3f34c3a935f5feeb8410"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a883ed087d09ff8b3893db30d4dce8ac750cc883c675a1e079af83017ecc6e98" => :sierra
    sha256 "48cdcf76f89bd11d71f43e7d69b8c4c66c159b65b9644b130bee75e26c2c64c8" => :el_capitan
    sha256 "c38fbdab997b8bdf2ffd0c9aac268d47e49ce8c20c232e2ee0f6f117c10dc33a" => :yosemite
    sha256 "8c51e1b3b4a2af7650d5b0fe1c67577fa8b457c7656db85572a55e342f0fc044" => :mavericks
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
