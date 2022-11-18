class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.51_20221111/wrapper_3.5.51_src.tar.gz"
  sha256 "5e4833820b452d80adde03f4178c2adfc4c51c2a28ff1f9b0f3cf3fd3aa6bc1d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8cfa2f92470f1d8a666658c5f2bef6eab0bf53abe21db76482882792e41d918"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2c14b3893101f056fdd68864726d791b77917455058b0b3fbc7fdb5fb736ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "948fbff85cb90372a7e83f81736155f1fd47137dcc1087855cfd4287cfcf728e"
    sha256 cellar: :any_skip_relocation, ventura:        "c889d8e2e4c1b7e26459049c834304921ff3c1c8d271b68f94e24633a166436e"
    sha256 cellar: :any_skip_relocation, monterey:       "acc39a0d13c9e76df08f925fa2c51db04eb3750bde9b3185f115ce1b6dd076dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "45d19d745fd7709f6844bad90429ba9b4f61a6d714414dbcdd193b92e536d898"
    sha256 cellar: :any_skip_relocation, catalina:       "f18c55c09c27697e6efb78f4d34e94a2bf3b71dd21c6c64227278685cdd604f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c492f5312502fadd421dd4e95a81f9ba5f9f10d25786ab022051d69edafb821"
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
