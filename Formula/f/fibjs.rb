class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.36.0/fullsrc.zip"
  sha256 "50b77694c36bc3836be7494807f973e4abe902ea53d8ddd0689978c9be736df7"
  license "GPL-3.0-only"
  head "https://github.com/fibjs/fibjs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98a0645201c055a9ded884cd4aa295cf5db146dc7c16f3c35ad3a237ee81b0de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "957f1c2ea1c2fda1fae9e3d3dc2b8a7eb8e86461db1d80d971d6a29c17ab5f91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d0580537b11fe5b885cd42eddf0fe80ddfc4e64ea34a8dbc93d3ac5facc0810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f13527748224a30f02df32b6c4d646fc8553adf6a102c37d6db27711862d46fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae91a62ef0830d4338a48997c9c0222a3d87d523f5a55bc31848793699c488eb"
    sha256 cellar: :any_skip_relocation, ventura:        "3f5a3097bb48103fdb11f3785e10a956047cd0e40b79eeb3aa2d38fc8c609067"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2b6f88afaa6ac05291b9d168da823e5cd9b2c3138558d1acc9f04a9ae1edc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b14af84e2cd27204357367bd5219fdf4c6a18bd2ee9261b5fb8ccb5fc5c0f55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b91f919f5e2f780b851335ab09056019f043b3dc91c9f6338aefd8e59b2f1c"
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
