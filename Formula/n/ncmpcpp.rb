class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33c0ecce7a49585a844ed78e18f7a0d489eb6e07f0b20686e8df4e7ae3a28343"
    sha256 cellar: :any,                 arm64_sonoma:  "ed5a1603e63554209315bd505e6af8785ba2d1e2e555089b44355829493d81c5"
    sha256 cellar: :any,                 arm64_ventura: "2432a2868bf904bf0aab5ab13a94396298bb0f316a295ce983808a4effb06eb2"
    sha256 cellar: :any,                 sonoma:        "a2ce4e5cc19fca1daab19dbbcc44d4293ce40baa4ca35d3779b9fdfd64893629"
    sha256 cellar: :any,                 ventura:       "bdff69cc2753dec867228e68478eb72f69173b3c5abff5ac40bf8919f2b1092b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880fef15768b5ffce305529168d746b6ee0f37d29036ef9c948daf2e6cc74516"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "icu4c@76"
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
