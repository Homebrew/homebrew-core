class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.2.2/fish-3.2.2.tar.xz"
  sha256 "5944da1a8893d11b0828a4fd9136ee174549daffb3d0adfdd8917856fe6b4009"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "10789988100d68aba59a0b2a77c8e081e6603a99e685a4e4bc793402f750e76b"
    sha256 cellar: :any, big_sur:       "a1fff416cb486056960c941fa366f817de8dbb020bcd5467f2c63bfc6189b9c5"
    sha256 cellar: :any, catalina:      "cffa526865c495b8647caab5b24f84641f509e0048d67b57da97b4968ac05b6d"
    sha256 cellar: :any, mojave:        "8f8e193e965064a81c1da63fcce32cc950d5c3d54c319eda252b2b30289c612e"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", shallow: false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
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
