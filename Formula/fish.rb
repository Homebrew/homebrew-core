class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.1.2/fish-3.1.2.tar.gz"
  sha256 "d5b927203b5ca95da16f514969e2a91a537b2f75bec9b21a584c4cd1c7aa74ed"
  license "GPL-2.0"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ef7f5a2fd69ba2baed78d02ee162cc8fb85644161dd765d47b570b56db9569cf" => :big_sur
    sha256 "b1257836de799a5204be8289bde8008b616c2fc070b22fec914e044f0a4bd8f2" => :arm64_big_sur
    sha256 "b158b7f8640feb7c622ff3ca92b1bd88565f274f3e761499f5926bb124eeff7d" => :catalina
    sha256 "6797636eaba364d0cbbc0459103a8767598e985f01846cca6cb57c986dfee7b8" => :mojave
    sha256 "2609577a0d9f6b661331adccf5d1d8e010662ffe128869757e0af9a6760e26fb" => :high_sierra
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", shallow: false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    # Disable code signing in cmake, so we can codesign ourselves in brew
    # Backport of https://github.com/fish-shell/fish-shell/issues/6952
    # See https://github.com/fish-shell/fish-shell/issues/7467
    # Remove in 3.2.0
    inreplace "CMakeLists.txt", "CODESIGN_ON_MAC(${target})", "" if build.stable?

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
