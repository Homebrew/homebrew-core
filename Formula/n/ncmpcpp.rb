class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85bce87b0b6063cdbf8be5b857c8a2d411a645d11f37f12d66dc99431bf7b034"
    sha256 cellar: :any,                 arm64_sonoma:  "ac040b1f822500333c9193ebab20bd7910598c23a8e6aaada597ade970137a91"
    sha256 cellar: :any,                 arm64_ventura: "317dbae909e32339ebf1134a8ae55bf0f609d04c5050a183cd644fcf2c301c10"
    sha256 cellar: :any,                 sonoma:        "f6d94110dc3839f47f1011b489eb4aaf82d7afa2e8bd55484baeae6d178c41c3"
    sha256 cellar: :any,                 ventura:       "0651a6f3101ce2af14a7e4af064bc6a765244966db3fe9afa6da2adf0fcc8c4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08416eed22effd6c038ac64dfa1a7955df0ed74633fc8bb105b64207c22047c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad7efcda3ef45c061a14d4b0517d8b4eed7ba186085e7abc6ad559167bc4873"
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
