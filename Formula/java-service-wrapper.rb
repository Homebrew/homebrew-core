class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.48_20211222/wrapper_3.5.48_src.tar.gz"
  sha256 "c2800d8702ce86f4e7abe06773ccc220364424ebf7b3035f788ff79d0ed8d523"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfe954f1e2818159969b65a8827a5048fc1e5a17ef00d09e81514d24b203e59f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3662f2ce752f3fac6be12507f322a57db4df015295f80e27e498924c4b07ee5"
    sha256 cellar: :any_skip_relocation, catalina:      "477573da161e4aeb9d3f2aad6c61118637c7d820be41e9ba5a05907e2f99fe5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beae6563bdc7ea5e69b0eb4eae28eabf85fb61515c17ee4261b6b9a2a54ea947"
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
