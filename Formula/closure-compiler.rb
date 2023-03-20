class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20230228/closure-compiler-v20230228.jar"
  sha256 "8fa53351d2b7e9769697fed4e323fac2fd216e02d95136ed0f8a1d357f9bc307"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, ventura:        "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b4d8a76512026d3c59aec84ed9b8986eb9825548616e14725895fde20fe87a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e113b3243041ff959f785c31e26efb8a6813a6c6e93ff624c74a85afd378f252"
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
