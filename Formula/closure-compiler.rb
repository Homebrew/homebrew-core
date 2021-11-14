class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20211107/closure-compiler-v20211107.jar"
  sha256 "733f00f0a1651c9d5409d9162e6f94f0a3e61463628925d3d6ef66be60ec14a6"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4df4438a636ef1af62144b79ba93b55f165d5c1b12e1f239f81b3d00f7f36129"
    sha256 cellar: :any_skip_relocation, big_sur:       "4df4438a636ef1af62144b79ba93b55f165d5c1b12e1f239f81b3d00f7f36129"
    sha256 cellar: :any_skip_relocation, catalina:      "4df4438a636ef1af62144b79ba93b55f165d5c1b12e1f239f81b3d00f7f36129"
    sha256 cellar: :any_skip_relocation, mojave:        "4df4438a636ef1af62144b79ba93b55f165d5c1b12e1f239f81b3d00f7f36129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b574f7e1c32f439d7e73a1cd835faa2b4055cdafe1a2b3728cc32a28f45493"
    sha256 cellar: :any_skip_relocation, all:           "14ab57680ce20aca0ee384133cd0426c1f1eb89b17dd28eb1511459c3c06cd32"
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
