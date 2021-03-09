class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.2.0/fish-3.2.0.tar.xz"
  sha256 "4f0293ed9f6a6b77e47d41efabe62f3319e86efc8bf83cc58733044fbc6f9211"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7071739f327b442f6d1bec65332c33d29cb0833fd601a215d4d3492dbf188614"
    sha256 cellar: :any, big_sur:       "9891254ae3507ac79a050fc5ef5a837820ab78f06ad7ab5495a61a3e83bfb970"
    sha256 cellar: :any, catalina:      "dffc718a031961c893db21b189b2ae81a4ed65b7f1d1ae77ac7a83fd6a62038a"
    sha256 cellar: :any, mojave:        "274a7590ffb5f2252ed2fc1ca97164c8ec77808312e48a2a0d794987e692767b"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", shallow: false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    on_macos do
      args << "-DSED=/usr/bin/sed"
    end
    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
