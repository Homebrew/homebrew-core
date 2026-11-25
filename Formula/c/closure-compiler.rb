class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://repo.maven.apache.org/maven2/com/google/javascript/closure-compiler/v20261123/closure-compiler-v20261123.jar"
  sha256 "ef7bc8052c1643a23b9152ff2dd6192c94cfcb2aaf8dbd035e20586998940e66"
  license "Apache-2.0"

  livecheck do
    url "https://repo.maven.apache.org/maven2/com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    manifest_sha256 "b8b6519655cef4ed36725e65272523b4327ceca5ff50d8e79b6d0937685083c9"
    sha256 cellar: :any_skip_relocation, all: "00cde923c7d81342dabc18e0ef908c522027bd104c20f7567b8584b32f6cf61b"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"closure-compiler-v#{version}.jar", "closure-compiler"
  end

  test do
    (testpath/"test.js").write <<~JS
      (function(){
        var t = true;
        return t;
      })();
    JS
    system bin/"closure-compiler",
           "--js", testpath/"test.js",
           "--js_output_file", testpath/"out.js"
    assert_equal (testpath/"out.js").read.chomp, "(function(){return!0})();"
  end
end
