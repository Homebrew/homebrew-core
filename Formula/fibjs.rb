class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.34.0/fullsrc.zip"
  sha256 "57ff82526307274a59cf5d373f57d2aa7690e5b3e4c31a916de4f048fd84bf04"
  license "GPL-3.0-only"
  head "https://github.com/fibjs/fibjs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "71a047b154c8833d08c7f1d56f148bb4123a14a03786c8e98217c49ed56da038"
    sha256 cellar: :any_skip_relocation, big_sur:      "5b94c5a2291ada6c8987b23357ea3c0be4306d2ead6caca2b236a73643947d7f"
    sha256 cellar: :any_skip_relocation, catalina:     "74a446f80b494dee49981e4fa0dc68fc1653d81ba09dbf316e5bde3100360030"
    sha256 cellar: :any_skip_relocation, mojave:       "0489b047454da54566d071fddfc011c91ca8c44620631a1aebe359c887fb65fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7992458fb9fc9ab2aab41cdf12f7f68896c21202c9499d9a0900b32d1dfc7dd0"
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
