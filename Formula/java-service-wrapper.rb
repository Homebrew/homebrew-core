class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.49_20220209/wrapper_3.5.49_src.tar.gz"
  sha256 "81c49c1792c8a96541bfc7ab237846e6db790593ced979611400b3d58eb4fafe"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84b04de30d5752338cb1fe363604a0e2fac4ad5448891b43cf2db24d2ec3a09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "936b138d8bbd524fe0c676b6f47ef5a4c67404fa11d3a3d88240800489a0e23f"
    sha256 cellar: :any_skip_relocation, monterey:       "51f23410153cd00c6cf80821ab3732db0f25792271e4a13208c07a5dbe890b5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "404c97324a4b76bfe9a2799a65d779a4cbff8762ded3f1e7fa0418c6cf98fe0f"
    sha256 cellar: :any_skip_relocation, catalina:       "3dd1fe51ccdd44b60bdb9bd1e6f9419868a39066f72e477cb85d41db95a68f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775861a1213aba71ce9605bd2aed80f78cd0110ed0490b328823399f36efefe8"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11" => :build
  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    # Default javac target version is 1.4, use 1.6 which is the minimum available on openjdk@11
    system "ant", "-Dbits=64", "-Djavac.target.version=1.6"
    libexec.install "lib", "bin", "src/bin" => "scripts"
    if OS.mac?
      if Hardware::CPU.arm?
        ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib"
      else
        ln_s "libwrapper.jnilib", libexec/"lib/libwrapper.dylib"
      end
    end
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_match("Test Wrapper Sample Application", output)
  end
end
