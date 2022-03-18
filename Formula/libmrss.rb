class Libmrss < Formula
  desc "C library for RSS files or streams"
  homepage "https://github.com/bakulf/libmrss"
  # Update to use an archive from GitHub once there's a release after 0.19.2
  url "https://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz"
  sha256 "071416adcae5c1a9317a4a313f2deb34667e3cc2be4487fb3076528ce45b210b"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_big_sur: "7c1c62cdc4b99cfc4367d8ce1523f06abbf3f8b115ef75c924f12ae40690dfdf"
    sha256 cellar: :any,                 big_sur:       "a64af37616c940a615987f40bd729ffaf9d190186ef2823a51f46ff13e318231"
    sha256 cellar: :any,                 catalina:      "03a62a0d10dd05156876128388b1081c329a00f38d71d6e8b52bff20b3d40fbe"
    sha256 cellar: :any,                 mojave:        "66000637d850285b2fd66f2fc00ae5a3096690ec84b8280037c39bff3246612c"
    sha256 cellar: :any,                 high_sierra:   "234ec50cc4eabdd5433abb2d27f1e359c468db4fda10a36eb2c9278034a4e000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8913d28bfed0e28e74935e3700fe71d2591da2d8ab2c8d3929dbd6ba7cc4786e"
  end

  head do
    url "https://github.com/bakulf/libmrss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libnxml"

  def install
    if build.head?
      mkdir "m4"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
