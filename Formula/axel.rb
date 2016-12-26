class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/eribertomota/axel/archive/2.12.tar.gz"
  sha256 "28e7bb26b7be3f56a61b60ef07e15e05ea9a41850b0ed45a0c56d6d2202f4a8b"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "4328a6116a4e5fd3f19398a256158f8623d2471a6c415fe63ba055199e724157" => :sierra
    sha256 "0bf17ed83896ebf161419fd6a57613c023430280893dd67f7c52a879df7e26ef" => :el_capitan
    sha256 "82f22d3449c483cbb5555afe13a59f7f18e604dc3cbc49550c11650c076dd7d2" => :yosemite
    sha256 "2580ae99bbe1a36e5bc4630398887e29a93abeacc0d2f1acbe894539bc5ea2bf" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
