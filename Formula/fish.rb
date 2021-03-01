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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1257836de799a5204be8289bde8008b616c2fc070b22fec914e044f0a4bd8f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef7f5a2fd69ba2baed78d02ee162cc8fb85644161dd765d47b570b56db9569cf"
    sha256 cellar: :any_skip_relocation, catalina:      "b158b7f8640feb7c622ff3ca92b1bd88565f274f3e761499f5926bb124eeff7d"
    sha256 cellar: :any_skip_relocation, mojave:        "6797636eaba364d0cbbc0459103a8767598e985f01846cca6cb57c986dfee7b8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2609577a0d9f6b661331adccf5d1d8e010662ffe128869757e0af9a6760e26fb"
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
