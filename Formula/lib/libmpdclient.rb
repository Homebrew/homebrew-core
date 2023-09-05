class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.20.tar.xz"
  sha256 "18793f68e939c3301e34d8fcadea1f7daa24143941263cecadb80126194e277d"
  license "BSD-3-Clause"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libmpdclient[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "375a77d9a5e35735bf4075b1d00f2a8e58e2c42db81ea84628376450290e5d03"
    sha256 cellar: :any,                 arm64_monterey: "cf069d8465152e64482a30cdd9be6d9db373eb6e033e20b36f5ed0c6ff787a81"
    sha256 cellar: :any,                 arm64_big_sur:  "5b121fcd7d0df82dd8b3f9ee14f2084441e3cf4ad116d7b9deb556ed06fe2244"
    sha256 cellar: :any,                 ventura:        "cf82a221e32a91e34931b38104bb0d307e5983dd8aa0e0e24188796fc3b8e6bf"
    sha256 cellar: :any,                 monterey:       "c929f3eba925610a9482592c5f541686258facc2ae2a366ef85cddcb42827135"
    sha256 cellar: :any,                 big_sur:        "118c8e3f7e28a00346eda41e6f7c50a355c250ae797d828cc0a944f87e67767a"
    sha256 cellar: :any,                 catalina:       "5bc8f8811db3bb6ac41f013c216fde9241674df6c6c8b37543fb1930d907cf28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "798eacacec842e16efa4e6025c3199132ecb8c5980f82315440ece2748cab7f1"
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", *std_meson_args, ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
