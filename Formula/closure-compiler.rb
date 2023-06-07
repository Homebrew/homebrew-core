class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20230502/closure-compiler-v20230502.jar"
  sha256 "87f90a557e3d2ae8af430ac6f4a42becf1b453485e890999777a52c90bda9d22"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4a390a67013f890c4ce007ccd40b0492adef1cc0e6415f52407b3954c1a63f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4a390a67013f890c4ce007ccd40b0492adef1cc0e6415f52407b3954c1a63f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac4a390a67013f890c4ce007ccd40b0492adef1cc0e6415f52407b3954c1a63f"
    sha256 cellar: :any_skip_relocation, ventura:        "ac4a390a67013f890c4ce007ccd40b0492adef1cc0e6415f52407b3954c1a63f"
    sha256 cellar: :any_skip_relocation, monterey:       "ac4a390a67013f890c4ce007ccd40b0492adef1cc0e6415f52407b3954c1a63f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac4a390a67013f890c4ce007ccd40b0492adef1cc0e6415f52407b3954c1a63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dac41e1d0eadbef230b6c8209b0ed93861f8bc5630a97231c329a3648fdbb9b"
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
