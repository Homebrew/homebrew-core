class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.37.0/fullsrc.zip"
  sha256 "51908a22a5ddbdb2c772c2cf08ba61cee96d89a4da0f678014423b86690478fd"
  license "GPL-3.0-only"
  head "https://github.com/fibjs/fibjs.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fd81ea326f8dd8bd3ed2c7fbcf7856d00b13d699d26f88d0baf34e07d9367207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f940f6107a3dd1035e68d8be72bd46d99d90a23cf254084572c5d005323babfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bf3d1703cf3e662ebf874d2cf05ccc2deb41ef2502d30344d20f80744441cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1f5e64e73171ae6d553bd8552e17d3df8af6c69d6098c9c36819e463a20c70e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "648b4f2a523f2bb94752aa9986562da94c04f3b66ae6bc11e7fc46c13d6a8a7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "db4327b9a6f16d42e8e568e635a84b4acc2726b3740a928221f1876707574a9e"
    sha256 cellar: :any_skip_relocation, ventura:        "1cbe5e6746b9d0d30283d6fc587da0c9bb5d91b31b717e7563ab48e959c8e4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "bfd772e6c231fbc20044c6c72ded9e8ebab219e6e166778ee1c6341747415aef"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3dfbb08919d6b3152be45d24e5267d0026db256b1936c08e49bb562ff9e76296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623b81dd27d99e33d98b905cd33a756b9b1f70a1ec3d2399370f1e48ba108f0d"
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
    # Fix to avoid fdopen() redefinition for vendored `zlib`
    # Issue ref: https://github.com/fibjs/fibjs/issues/793
    if OS.mac? && DevelopmentTools.clang_build_version >= 1700
      inreplace "vender/zlib/src/zutil.h",
                "#        define fdopen(fd,mode) NULL /* No fdopen() */",
                ""
    end

    # help find X11 headers: fatal error: 'X11/Xlib.h' file not found
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include" if OS.linux?

    # the build script breaks when CI is set by Homebrew
    with_env(CI: nil) do
      system "./build", "clean"
      system "./build", "release", "dev", "-j#{ENV.make_jobs}"
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    bin.install "bin/#{OS.kernel_name}_#{arch}_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
