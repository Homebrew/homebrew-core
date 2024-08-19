class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.59_20240723/wrapper_3.5.59_src.tar.gz"
  sha256 "3b47e7facdd1208ae2570eac301da748a006b551744f3e8db3825bf4ea5c6e06"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3686c79400a6d08357b9732a90552c682e79d20e0452a7f3fa5ed9a0a9b306c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afec02b0f155c2b525aae172c8a4769e8b6083dae7ec542d08c762422c21a8f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d59c6dbb00c3831526d7a2c3d06d559c242ec36c27f527b29d2a7e49e6ded3a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "77f657d48b8c15e8902bb346d2f3081b5b705cd74f7965bcfe626a7ca0f69e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "b13c9d5321c9239ad342dc4375203df491e1ec89ff072a9214d6aee1ec131c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "52d7a21a1b0a06e1b4311718b4926f58a446dc125f761edade0e1898888243f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "187b9c59b2589c36223445d0b0fd9d4985dccaeca299ed046ffca2c1b2565f6d"
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
