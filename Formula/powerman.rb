class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://code.google.com/p/powerman/"
  url "https://github.com/chaos/powerman/releases/download/2.3.24/powerman-2.3.24.tar.gz"
  sha256 "85d5d0e0aef05a1637a8efe58f436f1548d2411c98c90c1616d22ee79c19d275"

  bottle do
    sha256 "1c5fc630daa743f59a60d9db27d4660aa02a8d629e40d3dfeb6d8a77ebb8246f" => :mojave
    sha256 "d451560676e07f1ae3f3d8b72c025bc8ad77cd9c31f52bb52cbc96e3f82ce178" => :high_sierra
    sha256 "c31cb738ebc06c20c07cd2c6c10ff69bd21df62657cbf7f5d08a8a54317f0fc5" => :sierra
    sha256 "26b893065e1f5e2f345d8b75fe2770bb4616fb62d7aec73022c4472df8158b2a" => :el_capitan
    sha256 "e90be29b1ab6ab310f39775973edbaa647a0ac12d81bbde374bbc5ed262c317c" => :yosemite
    sha256 "412042f83e03f1cbd9e285b1566bb785471dd79f93049df8bbfdde3544122a24" => :mavericks
  end

  head do
    url "https://github.com/chaos/powerman.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers"
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
