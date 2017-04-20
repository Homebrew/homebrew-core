class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-3.16.tar.gz"
  sha256 "2f753094e4df3cdb1d99be1687c0fb7d2f14c0d526ebf03158c8c5519bc78f54"

  bottle do
    cellar :any_skip_relocation
    sha256 "319f94298fabd8f9082d8ac7ec1847854e29ef8e83e9b6a2b38e00a6083292a5" => :sierra
    sha256 "bd2241c422b94b28dd026577ecd56ddb91b17e95820c4ac7ed15f5b006ccd495" => :el_capitan
    sha256 "ac30f452132325cc9b4223032a6d547a4b436c2e51b4db41e45cd906a18bcfd1" => :yosemite
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
