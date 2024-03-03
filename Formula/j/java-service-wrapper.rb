class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.56_20240227/wrapper_3.5.56_src.tar.gz"
  sha256 "cd97c93ffb9fefc0ffe86e752a6d5b351448bf98bcc7af57c3e8a6868e3f6694"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b2cf45b66d03fe19863a1f9497cca8ff979864389624b83f9d3c6833f95b82f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "963631c202195828963a0e4f51084c653932146cc4f7a07df6d71c3093385a24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "978679a0359ccff57bd4c390ca3b177769d6ad7a0696e318456d467166dce13d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bbc33e86bc1420382447510fc97ed045646cfdd0e9926aa9671a2ddcdb1a78c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab12f140966eeeeba6a39e1c7df802782bf43ac5ada2962a94d157faedd490ed"
    sha256 cellar: :any_skip_relocation, ventura:        "c6dbfbdfb09a5403b653648ece2f749d074b22b1d45168801f209469c74f1d9e"
    sha256 cellar: :any_skip_relocation, monterey:       "364d3b98e673d49034f8cef5ef18392d22e9053c064a54906cba8f3549f6b481"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6e62d97d66dcd8fc9a6fc48ea07b15cc0f049f160760dff6363959f3839dbfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f48798bf4a7f995c03626fd3ed94267fb3847c112d804da52a1fd45403aab6"
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
