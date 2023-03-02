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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad6c747abfc447eb6e8d83a14bc18e0ece857f7385ec2d1692498af8016d11ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2daddf26cabe9499a17582bc21b1959eda16beb59548b4b6d43c5757c4aaea20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5df9ea4fb121c47606fe5c6595c28bad90261e4a4997819efe960c635b462963"
    sha256 cellar: :any_skip_relocation, ventura:        "75155ea0159798fde2e4f62fc80b821a872dbffa3cb638075ead4039bb347823"
    sha256 cellar: :any_skip_relocation, monterey:       "71bc66b4a4d264def397f933ccdbb6de71ae8595412c4db51a29e8fa94d4a54e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b40d875fa5925ae3ba1084bd10a46b0d9b0a6cbc22958aa6bd1103747ad7b9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e845a0bcbeb17659dac88fc873cc411e793fcbe124cd743134b4ceaff40f571"
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
