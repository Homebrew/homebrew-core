class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "http://invisible-island.net/mawk/"
  url "ftp://invisible-island.net/mawk/mawk-1.3.4-20160615.tgz"
  sha256 "230a2a2c707e184eb7e56681b993862ab0c4ed2165a893df4e96fac61e7813ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "140cb2b2b1054fa25390ebe43e26de53482be5587a401b9137b2a7d1011a6281" => :el_capitan
    sha256 "d513669dc87cf81fc1526d1784191f613837b871bde25e2a3eaaa0b7f0d991ad" => :yosemite
    sha256 "e116bc17922da25b037f2b5cf15f93cf0f8f535efe5fc3435cf337af10f553e7" => :mavericks
    sha256 "3d38eee059da9baa8aa70feb54b9e1eeaff8023b80bea0dfcd482039ee971476" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    version=`mawk '/version/ { print $2 }' #{prefix}/README`
    assert_equal 0, $?.exitstatus
    assert_equal version, version.to_s
  end
end
