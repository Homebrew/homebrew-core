class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20230802/closure-compiler-v20230802.jar"
  sha256 "230a9e05a8a7d9daa083b1f6e86edba6eb1ec6402a6a258432fe4245cdc4a95f"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, sonoma:         "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, ventura:        "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, monterey:       "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, big_sur:        "c664fa2caf7edcdd94bca7f618998e7c94d3a96c693ebf1eaa8dccfaa3622029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418732010dea41f438bf0437cd4279596b9ee72a6d1f040445044bca7015cace"
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
