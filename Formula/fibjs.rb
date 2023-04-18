class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.35.0/fullsrc.zip"
  sha256 "938e148064413c381d9e900e9160dc02a1d68376dfae681ba288fe2fbb8924de"
  license "GPL-3.0-only"
  head "https://github.com/fibjs/fibjs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "cb3c4cd646f77e5ac95459b94bc0dde23233175697dabe800020c7167ff84662"
    sha256 cellar: :any_skip_relocation, monterey:     "01ae2f16b8a0aade5cc4fe5bdf332f736dc246978901b5e921b31a8f801ee248"
    sha256 cellar: :any_skip_relocation, big_sur:      "722369e2f61203eaec7d43d2788443381c3335e976bb78f2d1665526914056d9"
    sha256 cellar: :any_skip_relocation, catalina:     "b72ea1b966a3749f4dca1bebfa6bcaaa10ecd64c33f19b50e3f27990e387094e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9899a7f2c1acf1b1cdfb4e744ddf5ea112e3016ca41e46e7b346bbdf9cb19664"
  end

  depends_on "cmake" => :build

  # LLVM is added as a test dependency to work around limitation in Homebrew's
  # test compiler selection when using fails_with. Can remove :test when fixed.
  # Issue ref: https://github.com/Homebrew/brew/issues/11795
  uses_from_macos "llvm" => [:build, :test]

  on_linux do
    depends_on "libx11"
  end

  # https://github.com/fibjs/fibjs/blob/master/BUILDING.md
  fails_with :gcc do
    cause "Upstream does not support gcc."
  end

  def install
    # help find X11 headers: fatal error: 'X11/Xlib.h' file not found
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include" if OS.linux?

    # the build script breaks when CI is set by Homebrew
    with_env(CI: nil) do
      system "./build", "clean"
      system "./build", "release", "-j#{ENV.make_jobs}"
    end

    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "bin/#{OS.kernel_name}_#{arch}_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
