class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/refs/tags/7.0.0.tar.gz"
  sha256 "91b41874cf5e323ca50a7e1fa15170aa3fb94591842df20ea394cce4a065ef9d"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebda326741afc7c9870a625d27d5fee78100bf41c8f7033cd7a1280666171437"
    sha256 cellar: :any, arm64_sequoia: "7072242cdfeafd41d7b2aa467e75a7a3c72676c9f142a2514437444bce479723"
    sha256 cellar: :any, arm64_sonoma:  "c431abf175d457445a7291c328341ec64d9eb83d00968d1dc6fcc93d2971f496"
    sha256 cellar: :any, sonoma:        "a2622caff993cd421972bed535b7eb9b66a8fca2ea09a660b8a6a48e5302321e"
    sha256               arm64_linux:   "be9b1d9423b60780d7d59bcd8c1ad272b52bab3fd05457506562319c38f501e6"
    sha256               x86_64_linux:  "07f783c023c9984a1722041757a98540205cb9a5d79f0df463d9e5a23bae2e54"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--enable-cairo",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
