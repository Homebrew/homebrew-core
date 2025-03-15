class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0d6d66b52bbde9ac2b26195b9bb6f88e223d0388cd538699dd2af6fdc92fa38"
    sha256 cellar: :any,                 arm64_sonoma:  "ebb3ffa1f982964c387218471494d6d21cc15ed7f66ce4581435e0228c5fbce3"
    sha256 cellar: :any,                 arm64_ventura: "0cbcefb9440b510f823e923d1888896cd42944d748dbc7cec233ea8cac839f6f"
    sha256 cellar: :any,                 sonoma:        "27a28a65f4b7805490ea976c692dcfd547dca918260d6f61bafa6f2ea6b876c3"
    sha256 cellar: :any,                 ventura:       "4274e30bab72d68fa72d4c8cb66422c661a3c7c1a5af93b45bb9ea26924a62bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c4191d57c18c8e6cef1fefe9d2ebf5abcb031d8eaf92300e6080989c5dc0b7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "icu4c@77"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  uses_from_macos "curl"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.prepend "LDFLAGS", "-L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["readline"].opt_include}"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = %w[
      --disable-silent-rules
      --enable-clock
      --enable-outputs
      --enable-visualizer
      --with-taglib
    ]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end
