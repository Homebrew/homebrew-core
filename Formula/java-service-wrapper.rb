class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.50_20220513/wrapper_3.5.50_src.tar.gz"
  sha256 "570e7fc0dd18af7f5b6b1e176af84ce6efac0a0100ed00ab842d95dc1c41ed5a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2447aa9f2e257c6b7fa7cf17f4df29f908695d9e2275585f6a36257560837f9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "101668fcd3b114ec988b6ec87119b9b9f38b6c144d2eae0add593c1afdad051d"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc698eb778851d6c5c14383e90e34be5018121f5473cfe3834a41aa6b67b515"
    sha256 cellar: :any_skip_relocation, big_sur:        "763a03cbdef1dff1f0a31cc5257bda16e4264629df14f46612bcc6f8fbd87308"
    sha256 cellar: :any_skip_relocation, catalina:       "60129bcf63eb406d6b94f7ddce99c376d02525ab531c10b6bf87bcdc9678b4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee285ca317b6f149ff42c8c85943911477fa8e9a00fa47f283f8ff5fb0832e4"
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
