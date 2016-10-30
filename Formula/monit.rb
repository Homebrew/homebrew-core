class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.20.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/monit/monit_5.20.0.orig.tar.gz"
  sha256 "ebac395ec50c1ae64d568db1260bc049d0e0e624c00e79d7b1b9a59c2679b98d"

  bottle do
    cellar :any
    sha256 "be51a33474b2a3907899e345801a7af34cc5ae789beaecbadf747966928b4a87" => :sierra
    sha256 "ea87a2ad323cf9219f8c70cb902d506172855f8dc1ef7e7b31fddc813db57829" => :el_capitan
    sha256 "f51c2f901edf6939e3f90519fec401ce2912ec2be6e1a3a1c2a9c84970a31ccb" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
