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
    sha256 cellar: :any,                 arm64_sequoia: "a994876375a1db76829cbc6a8e19d3fb15e54d9e39c4ca08560c5ccc43f826f6"
    sha256 cellar: :any,                 arm64_sonoma:  "2bfbdb1fb89fb3f0131925d136e0f828fd4367d4fd04345966cd85952c77aad9"
    sha256 cellar: :any,                 arm64_ventura: "79daf4e1a2fd5d87a1b8fb52217e984f8770d96cbd9bb15fc643af7fc694203f"
    sha256 cellar: :any,                 sonoma:        "1b7bd50bbad8a2b761210ff1afb18dd8ead6dcceb0c93323dc2148317ff8f494"
    sha256 cellar: :any,                 ventura:       "0c632676de91a027cbfbeb31d91709d47b82f83183add3cca8a9229ca53c6372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c668f7f2d18ca0dd37efef5eac7e0a5b9bad851883f2e14775901c6531631739"
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
