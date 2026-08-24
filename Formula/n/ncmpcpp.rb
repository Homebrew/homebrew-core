class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 8
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e70df09ef0392be678b106644b84817842e5f7662929a69d091f1e23f002f5b"
    sha256 cellar: :any, arm64_sequoia: "d441950bc1e0da43d6a59a080d4ec899c3ee3241420b20627d7f469c0d357ae8"
    sha256 cellar: :any, arm64_sonoma:  "1aa131d853f48e829a66dbc8008fc2013af1f763da4712791ad611fd4cf4ac24"
    sha256 cellar: :any, sonoma:        "860160a2247e6c23fd944d93088ab8aa6101de5bbd864419cd66311e588c3246"
    sha256 cellar: :any, arm64_linux:   "295b3a2023ab805b8d62662c4c7deafa80f8e57861c089ab72e414e7e5295f00"
    sha256 cellar: :any, x86_64_linux:  "1cc1a9db3ce0094c788f17be56d9dcc769d871e5292f62b63fd24ca6ed29ab92"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "icu4c@78"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  uses_from_macos "curl"

  # Backport fix for build with Boost 1.89.0
  patch do
    url "https://github.com/ncmpcpp/ncmpcpp/commit/f67d350aa9beb2abdd12c429e97ae919e5b3102c.patch?full_index=1"
    sha256 "7fa67adf722fec69793f9aa53398195294402bb09519e7bd99b388b7f99a5e59"
    type :backport
    resolves "https://github.com/ncmpcpp/ncmpcpp/pull/636",
             "https://github.com/ncmpcpp/ncmpcpp/issues/633"
  end

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("readline")}"
    ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("readline")}"
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
