class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 6
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70f05ba4a05170c09bfb85fea422e84de641760e75a93b065341c4f169c61e58"
    sha256 cellar: :any,                 arm64_sequoia: "bcd9d9e4217c1f8436e4de984f3c178e18650016016050c1b7467cefd6ea8d30"
    sha256 cellar: :any,                 arm64_sonoma:  "239511ecd7495ecd5d2ee6fb77881da7fc61e71566e3e8def37b2da735eab7f8"
    sha256 cellar: :any,                 sonoma:        "4e76ad05153e67059365a51c9a665fa07dd4bc083e172f22553794c10f5aea95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a85365b4dbb871e9e1fde6ca97e5bdcfc27e311d4d5ddfc539cf7b2dab117247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c4640b8469447b4fff88888dd2e6ed186141aa73b915a48904ef0ce68318ede"
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

  # Apply open PR to fix build with Boost 1.89.0.
  # PR ref: https://github.com/ncmpcpp/ncmpcpp/pull/636
  # Issue ref: https://github.com/ncmpcpp/ncmpcpp/issues/633
  patch do
    url "https://github.com/ncmpcpp/ncmpcpp/commit/f67d350aa9beb2abdd12c429e97ae919e5b3102c.patch?full_index=1"
    sha256 "7fa67adf722fec69793f9aa53398195294402bb09519e7bd99b388b7f99a5e59"
  end

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
