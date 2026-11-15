class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/refs/tags/3.1.26.09.26.tar.gz"
  sha256 "e944132329c6613b686ba0fcd373b15ebb553c367a01a734af8519ddb095c01f"
  license "CC0-1.0"
  head "https://github.com/Oblomov/clinfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6da7459a4af0fce8e888837a9a3ea1d0bd8cd1572155bb865239323c772ed577"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6d143b4fef7c5021e5050db9dfb378385141e9c71e083d83126a9319207a7c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6dec10d570378544c0a49ec347e6510b1b0d453840eb0b0f0b117a05108414ff"
    sha256 cellar: :any,                 arm64_linux:       "cf9d1a5d6cbcbe208e7f483ca044674dff6f22ca006f61a75cc3650ef1dd10fa"
    sha256 cellar: :any,                 x86_64_linux:      "9c4f7686290e70ea80d4fae6afc8f9c1fc6278d747db3e444f91ab5d1b31a175"
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    # OpenCL does not work on virtualized arm64 macOS.
    if Hardware::CPU.virtualized? && Hardware::CPU.arm? && OS.mac?
      assert_match "number of devices : error -30", shell_output("#{bin}/clinfo 2>&1", 1)
    else
      assert_match(/Device Type +[CG]PU/, shell_output(bin/"clinfo"))
    end
  end
end
