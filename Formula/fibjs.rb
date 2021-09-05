class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.34.0/fullsrc.zip"
  sha256 "57ff82526307274a59cf5d373f57d2aa7690e5b3e4c31a916de4f048fd84bf04"
  license "GPL-3.0-only"
  head "https://github.com/fibjs/fibjs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e5a997e76a3fa661cbdf75cf61e3e53e093451c2c5e9a1e55a16e6b8742fb55d"
    sha256 cellar: :any_skip_relocation, catalina: "a93fbe33a0f6feca011ea1f21f69f2d5d72be12cc4b2ca11f217e53ad1a09c72"
    sha256 cellar: :any_skip_relocation, mojave:   "bef936d8399cb135a7073b6983ee41b0fb41e967c893a92db785f5d319ea453e"
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
    on_linux { ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include" }

    # the build script breaks when CI is set by Homebrew
    with_env(CI: nil) do
      system "./build", "clean"
      system "./build", "release", "-j#{ENV.make_jobs}"
    end

    os = OS.mac? ? "Darwin" : "Linux"
    bin.install "bin/#{os}_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
