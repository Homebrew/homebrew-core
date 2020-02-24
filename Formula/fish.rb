class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.1.0/fish-3.1.0.tar.gz"
  sha256 "e5db1e6839685c56f172e1000c138e290add4aa521f187df4cd79d4eab294368"

  bottle do
    cellar :any
    sha256 "af7faf2423941d4dcf226adfd9e765c41cdef1c6eda47ea24d17bce93453da2f" => :catalina
    sha256 "bcd31ec78f934fdc93eb1f06932e0af633c5183ab5af6a07f62c7102d994a4f1" => :mojave
    sha256 "1ae9a0d35982b3df3854bf3eb36365a65a269fbfa686cc0d95a667d20de4b73c" => :high_sierra
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

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
      -DSED=/usr/bin/sed
    ]
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
