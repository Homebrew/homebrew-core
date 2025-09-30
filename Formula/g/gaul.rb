class Gaul < Formula
  desc "Genetic Algorithm Utility Library"
  homepage "https://gaul.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gaul/gaul-devel/0.1850-0/gaul-devel-0.1850-0.tar.gz"
  sha256 "7aabb5c1c218911054164c3fca4f5c5f0b9c8d9bab8b2273f48a3ff573da6570"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e6d6c2c5f3c790afcff2232f8d2dc371a425fdedc42aa52a33daf94b0816439e"
    sha256 cellar: :any,                 arm64_sequoia:  "f6ef6f6e6711082dd49cae45e516aa9f8fdf0f2942ff4224f6c30d9e75976dcc"
    sha256 cellar: :any,                 arm64_sonoma:   "619d02cf0a65573901c3b83a642203dae07540475bb5e1ea054b67e9ae1ed086"
    sha256 cellar: :any,                 arm64_ventura:  "75cba0ced64826f1b48b0622ae5c7a3b2acbe99c33f7b97ec02378b3f97db95a"
    sha256 cellar: :any,                 arm64_monterey: "26e4e30f26cf04cd953e2ec43503a616d52a4024d2131cbcce5bc13d28ad93ea"
    sha256 cellar: :any,                 arm64_big_sur:  "bc5e55391514a4f15a9ce9c66e54cb3f430d255ebc1bc6edac681787c9b8ec9f"
    sha256 cellar: :any,                 sonoma:         "fae30be9623f54eafac733017939004e128f0b45ba6e554e5e3b3734371611eb"
    sha256 cellar: :any,                 ventura:        "0272c7461b39c0894221a8b21fa95601f3d0476bb6343cfbe12e76181523df3b"
    sha256 cellar: :any,                 monterey:       "4541d4d7d5d7ef43cc1acf3c57516e67fecf69e12f455f944d0a326816c400cd"
    sha256 cellar: :any,                 big_sur:        "e6a64a500ac22aec1a76616d86ea2f70449dfa30d37543faf9a135c2f98e1a07"
    sha256 cellar: :any,                 catalina:       "f2f98c2f7d23ae7c1862702c6d17d4449bbcc2164940d9157ea12b97deadb273"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "53fc9d9d00e8829b40586ca4786c0848b543d5f42b191bde994139d284371a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d80af0c4bdef2186dccac01b0046ca2ca2c81c484b7c5f279553b2e190b53c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Run autoreconf to regenerate the configure script and update outdated macros.
    # This ensures that the build system is properly configured on both macOS
    # (avoiding issues like flat namespace conflicts) and Linux (where outdated
    # config scripts may fail to detect the correct build type).
    system "autoreconf", "--force", "--verbose", "--install"
    system "./configure", "--disable-g", *std_configure_args
    system "make", "install"
  end
end
