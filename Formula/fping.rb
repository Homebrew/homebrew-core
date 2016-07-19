class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "http://fping.org/"
  url "http://fping.org/dist/fping-3.13.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/f/fping/fping_3.13.orig.tar.gz"
  sha256 "4bb28efd1cb3d1240ae551dadc20daa852b1ba71bafe32e49ca629c1848e5720"

  bottle do
    cellar :any_skip_relocation
    sha256 "5acae93b5ae34fe14b62a8b432cf49fff4a67ccfe3d4b1795730d055df72b2bc" => :el_capitan
    sha256 "e1fe3659afb3979ddceb3015297cdfe84637d1d303508376294a311b85540f0a" => :yosemite
    sha256 "c8a38daff4c51ffbfa0c76a75e84b574f1dc5e302c24edfc43336c3c6a70338a" => :mavericks
  end

  head do
    url "https://github.com/schweikert/fping.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fping -A localhost")
    assert_equal "127.0.0.1 is alive", output.chomp
  end
end
