class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.24.tar.gz"
  sha256 "973593d3479abdf657674a55afe5f78624b0e440614e2b8cb3a07f16d4d7f821"

  bottle do
    cellar :any
    sha256 "3cf730f34b1c7abd294027dc63d41c05f8030b59bca98ef6a202875f74b81162" => :sierra
    sha256 "218e853cb1518b865bc5e3eddda8f2dde1aa3d0fbdaef9a57d5744f32753d8f1" => :el_capitan
    sha256 "dec143577828c516a9c3d6b7d0ee917b92a1ca152cf51b8847f5f712a45fd4cc" => :yosemite
    sha256 "6d1791789a21f1b1637f56b76b4e49256adffcec6d13a337a16038d06f186f69" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end
end
