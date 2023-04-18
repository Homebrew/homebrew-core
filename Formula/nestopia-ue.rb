class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/1.52.0.tar.gz"
  sha256 "eae1d2f536ae8585edb8d723caf905f4ae65349edee4ffbee45f9f52b5e3b06c"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "4ce6ef1bf01bff15104f1e53ba5ec042e3a461e75b194eda957f876bdbf6549e"
    sha256 arm64_monterey: "ba6b9aac85e420c98c2100f74a91252681de9d87434b8e6ab4d95fe759ec9f21"
    sha256 arm64_big_sur:  "dcb04201bec25835b346096661f9a64bd8d69aa3935b878b298c5b5e7d6eca11"
    sha256 ventura:        "9c01e56c7cd81c3493ee4f77cf5f37f9bfe70e7b3fc820d9056b63fe7e03eabe"
    sha256 monterey:       "7c768b5fd6adbe764f3ce6ce57d2f58fa43838223d60e8ba4ad7b2a0cd760aa6"
    sha256 big_sur:        "0f819600c7711eb7602ccf9d1305e25d25f6ae0e6759414b7bf95e7aaf4684d8"
    sha256 x86_64_linux:   "d4d4cbc4d8ec82be9811d0ac13203506c478c7a191300af5da1e86e55e8f6f4a"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fltk"
  depends_on "libarchive"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-silent-rules",
                          "--datarootdir=#{pkgshare}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Nestopia UE #{version}", shell_output("#{bin}/nestopia --version")
  end
end
