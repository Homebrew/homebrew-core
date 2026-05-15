class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "670759732597402da6dd7e0dc4ed92675e15277f7db85c62e56e771b8ac59dd7"
    sha256 cellar: :any,                 arm64_sequoia: "6df0785476637cc036dbe07ffd3327a6e86aa03318785d66d416a370ed04df6d"
    sha256 cellar: :any,                 arm64_sonoma:  "061d5aa9b7f89797caaf12ec7effea0c97411be4ac3facb585c8fab1be8db540"
    sha256 cellar: :any,                 sonoma:        "fda14cd49fe94f6396050895bceed1de192828a2650423a0037ff175bb9c4f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "554b3da3b1e4925251ff8af6703013f911f8c76f915fce30ee478995848b76a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b52492754a82d66f7a3a4e094a22f34326d14884d8c443319a9e184a833533"
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
