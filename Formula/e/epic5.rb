class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-3.0.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-3.0.tar.xz"
  sha256 "96d47350c13a3d99019da0e6a04b0c7f80dab6ddba590bcc679dbb8acc1779a1"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "7967cdc3e555432aac46d1c4a868e325c0b49db4b68ec6f05fdac66cd6881548"
    sha256 arm64_sonoma:   "728f124c2b5f362e4bbe8d6e3baecb2d5879b15c72bef7cd95e183efcbdbc243"
    sha256 arm64_ventura:  "5bcc0fb914418bc0d0dbac3930c8c7e6b93140d60c8d99f15ca2ceee67a1131b"
    sha256 arm64_monterey: "6aa3584946b99c7f84015cc7dc2d981cf7e2975a0198724377e0627c8bfd1089"
    sha256 sonoma:         "6f4d3a6a16ed04870bd2078510fc609371175ae7fea48b059cf2579d611f317c"
    sha256 ventura:        "204221a2c3f2c493ed7d3dd5ecc69ee3f3ea5bfda516dc39d7368b571d5e8303"
    sha256 monterey:       "7eb33143e21bb1629c667ff5e2a6792598311b142c1ac052fae55402a869ef05"
    sha256 x86_64_linux:   "304123953262a1054e6d0830b1f690f052deb6e3d4023aa7b02d601af6dedad3"
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
