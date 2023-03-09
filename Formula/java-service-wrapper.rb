class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.53_20230309/wrapper_3.5.53_src.tar.gz"
  sha256 "9835e5b07fa2bbd09caa5330b5bacc89c030b910a52b55a63d8d9260817c512c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7afc3050718d9c2826d7085cc8555df0a7d9e310dd827bfaf8f870f10033c8a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2219b472b7b4fd67e7cb7083245b96f5772fe17e81266ff30d57956e267f86e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0be1155f459adf66ca9c0c8e4fdc20f63fedfd083e10ac8abacd9ebb3ecaadb3"
    sha256 cellar: :any_skip_relocation, ventura:        "ddf46c6defb6371cd3308dac66c1bca037b505edbd0ef1a1b0d071955cd30e42"
    sha256 cellar: :any_skip_relocation, monterey:       "65d6e4110c5e34d3d00a03e72579b64ad26e418477b5683e88b7f2e2d7811552"
    sha256 cellar: :any_skip_relocation, big_sur:        "3612e7eea8c6e62317962965e62e168a50489698bdc0d67026051b33ddcc2745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "781b137b40dd264fbac45f3c08744e165eac1bf8729b6279f43b6af6f86d8458"
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
