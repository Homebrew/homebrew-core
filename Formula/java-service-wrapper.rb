class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.47_20211207/wrapper_3.5.47_src.tar.gz"
  sha256 "1a171c7d81bcaf8ef1954c284668e51f5123d60559f381f19469163aa37e1651"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a60cdd1e6f8abb1d6cd31ae266d53620f5f629bd247bcd492046020aaea7d390"
    sha256 cellar: :any_skip_relocation, big_sur:       "65408a2f2fda060014437c9be66d54b9f96c95994fbb244ae0d7940030537c15"
    sha256 cellar: :any_skip_relocation, catalina:      "c0acca607c1675ef56f29faa605bcd0b38b26669f4d667bff96ff8f2e6d587e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c479348d72440037ddc518ce574a30d89b46f32d86da5f163d680ac7416a6a"
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
