class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.4.tar.gz"
  sha256 "dd5e8f1c9aead442e23b749a9cc9336372e62e88ad7079a2b62895b0390cb282"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/"
    regex(/href=.*?libdiscid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "906bf782b5afdaa39be07081bfcf814c58987cd261b18689bb945dcd0bcc30b8"
    sha256 cellar: :any,                 arm64_ventura:  "ab8bab81ac4ed46d45902acfea78260d20e2ce0616d6073ebc8025ff6fa7979b"
    sha256 cellar: :any,                 arm64_monterey: "896b72d31f4c99fa8e1064807501c1588002c2d1d651cf3179ee5052504dea7f"
    sha256 cellar: :any,                 arm64_big_sur:  "65809091e9b8c9e8fdbc3e68995a7d93e4d367d798e19bd48a6f8a87c87fce0b"
    sha256 cellar: :any,                 sonoma:         "48c1bfeb601d5d5a85af2ebea67e247d0a92db023268de10ee8b1e4622a2629a"
    sha256 cellar: :any,                 ventura:        "88e97449648d49fafdff023e74d9841090c8194f7d1a311eb1c16920dfa7221c"
    sha256 cellar: :any,                 monterey:       "b2d8bb666d78a7c0a3b3d32fbdc86524cee0d0f080f138de868d31979aca627b"
    sha256 cellar: :any,                 big_sur:        "c4d364091f700f65e2fd53f70b23f243cab80cf991d0e7febbd78b0dfb029e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0408adf6b787c2260b62aa1235ec0b42d8ee8a8892a035fd56e1392cebe41303"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
