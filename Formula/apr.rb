class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.5.2.tar.bz2"
  sha256 "7d03ed29c22a7152be45b8e50431063736df9e1daa1ddf93f6a547ba7a28f67a"
  revision 1

  bottle do
    cellar :any
    sha256 "b9165ea319ea97f7321921f72c373327eae74d8f7ad64ebaffe516baf3c3565b" => :el_capitan
    sha256 "61c2e06504d6581cc3066ee71b990ca96a85429245f453e844e9d5c4e22d3f9b" => :yosemite
    sha256 "ec000b6b752afcd8423f9cabd22920add92d79836d376f07a5630eca8a3a9ee0" => :mavericks
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"apr-1-config", "--link-libtool", "--libs"
  end
end
