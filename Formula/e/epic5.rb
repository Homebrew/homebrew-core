class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.12.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.12.tar.xz"
  sha256 "c89ae4fc014ddcf0084b748e22f47b46a85ab1ac9bf0b22560360ba8626b6da6"
  license "BSD-3-Clause"
  revision 1
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5209a0e6fb595e179556ec87ecb8ba080fe8802b6ff9d829775177fda5aab632"
    sha256 arm64_monterey: "a79602d8312fd7f4d9ed1cd5943ebf896900b33217e9d22e186644b8d434dd65"
    sha256 arm64_big_sur:  "59f284a1e7e852f151c02ac16a64ac23fff0a8018736e9db42108dfe4481c515"
    sha256 ventura:        "bae652c9a1a9dfa1e428fdba9b6e6c87f3d32669220be7b27989710129292cda"
    sha256 monterey:       "0eb4696dd63599841100cb9dc9d3d3c7da7535d53d576efb787e72accb73180e"
    sha256 big_sur:        "bd772ddbdb174d0b6e9b469c05f2ae6ed356ef05239dd81becc7b3f46600d2d3"
    sha256 catalina:       "946b9c949126dc8a77f6d3ac1e79a03873b71bcb00d561684c9af8c29ecdd12b"
    sha256 x86_64_linux:   "625c386a734ca3cdae4366ac6745633642aa130af22773050320202f1804c4e3"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
