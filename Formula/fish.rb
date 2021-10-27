class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.3.1/fish-3.3.1.tar.xz"
  sha256 "b5b4ee1a5269762cbbe993a4bd6507e675e4100ce9bbe84214a5eeb2b19fae89"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b430125b97436764cabb848183282fd286935f9efed025ef0c1fc3867ee6823"
    sha256 cellar: :any,                 arm64_big_sur:  "b38561f401a18c3347b34cfee074d812728bc027fc351eaab95a872564f102d9"
    sha256 cellar: :any,                 monterey:       "033e833995d38505bb14e784729d3fc83bc7860813eb9dd6ab2e644541fd566f"
    sha256 cellar: :any,                 big_sur:        "eb6c0068f4a2fce0992048d31f1204ebaad31237a17e2ada18843a54afea162c"
    sha256 cellar: :any,                 catalina:       "50b1d13f3cf765f6b7933b317e48c76bcd42ce65fb5cbd5eeb1279229d6937a7"
    sha256 cellar: :any,                 mojave:         "25119dc2f23d89aad5666dcd6ebdf58a1c250c5a86942c187a65b72ab19e287c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13846c25ad06b9327782e430ed9e7e1d7faec4712704a28001b65ba5073df84c"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
