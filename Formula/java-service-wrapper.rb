class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.53_20230309/wrapper_3.5.53_src.tar.gz"
  sha256 "9835e5b07fa2bbd09caa5330b5bacc89c030b910a52b55a63d8d9260817c512c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2e4906d059d501ea1db569c91ca01de2941d846afa1ab28f1536a46364933a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32ef7d29fb9bdeb59b64d750c83e0128b002f71f7ab573cb77c9cb4eb3cc0d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d947bf6622eb15597757d2a240ba3bdd7f859f46c2b4a6a1c29434ab3d323fbf"
    sha256 cellar: :any_skip_relocation, ventura:        "4bf2af977b03796c94e6a220f52b7ecff45ef92fb85c31719ae7af4a3d0c304e"
    sha256 cellar: :any_skip_relocation, monterey:       "27792472bb02861081e3cbb2ddd8126268798414d8f740215a324d0d2e108d65"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca7b33bcc992e892fde65936484749ac9c21dbcd1ce959de7d798c4941006c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8f13e531a6ef5b28963a6eb9084c07b52c1c75e2bdeee58afc2ffcd21b3082"
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
