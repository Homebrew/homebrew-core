class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.48_20211222/wrapper_3.5.48_src.tar.gz"
  sha256 "c2800d8702ce86f4e7abe06773ccc220364424ebf7b3035f788ff79d0ed8d523"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf865b681713fc4139699491e6ec9e6c40987d95bb3a0ac2bb8c1a13ad578ba8"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e657672962ca9f5ec05befd497e747063b1ebe12dd536321ab212eeed844994"
    sha256 cellar: :any_skip_relocation, catalina:      "4a63f33390a0c0f0c33ce9360e01a96c4b168e5a30acf4e9b73685d8db517ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc431c3920fabaa7707f2c5c3a9f442b4aed0d8fcabc67f337e1b4b815b5f6d"
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
