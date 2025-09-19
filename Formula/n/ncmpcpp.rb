class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 5
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3b64ad56ef955187393786a72253bada2104c2ab0bfe8a1d87e83152168ab89"
    sha256 cellar: :any,                 arm64_sequoia: "ab2cdb4e9ebbc534f357141478d9ee1ce90008b9b454b764f23aa65dd75e8306"
    sha256 cellar: :any,                 arm64_sonoma:  "db5747c184ff0bd08ccae2625abbbb979fd6ca805a75a6f1334ca7cf17518f02"
    sha256 cellar: :any,                 arm64_ventura: "c7abc5c178c61a8d14d44a4359b46920e22cd3754f00c43f61a219269bde2c7e"
    sha256 cellar: :any,                 sonoma:        "bb881fd10d04a5246dc04bd049d3176e3d8358a5b9eb20d69ce9785a6be7506c"
    sha256 cellar: :any,                 ventura:       "2713786388b5263f07891669f0e50d9e5b06fc07e68a8da0c6c61c9c09e3e5eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50fb6bd68f50f189b94e50116d6eaa9abfb8519037e3635b7a7acb0e9d764e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3c0e5ede7bab231b8063f79d3326578b51ece94ab0c5c028694eba5e3bf05b"
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
