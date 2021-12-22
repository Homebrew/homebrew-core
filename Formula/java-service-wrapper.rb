class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.48_20211222/wrapper_3.5.48_src.tar.gz"
  sha256 "c2800d8702ce86f4e7abe06773ccc220364424ebf7b3035f788ff79d0ed8d523"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdf2be94e019f0659f1152c5fa7f35ae8657ef756aee41b93c610482c9b88c4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "98fbc9f69c89b1af66b28040fa864d71798511ae1759db6b51c7cf4f622d2aec"
    sha256 cellar: :any_skip_relocation, catalina:      "10547b35780adf985da0545d6772ca2bb9307f9041e50e4a243f9a57bdb14a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3db383ddac93ad1d3e4d6fd9c76a8f9fe027a280d3c1314fd605208c267ef5"
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
  end

  test do
    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_match("Test Wrapper Sample Application", output)
  end
end
