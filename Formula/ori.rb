class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tgz"
  sha256 "a6dd5677608c81d8cda657eb330661b5f9e0957a962a5588473d556ddf49f15f"
  revision 1

  bottle do
    cellar :any
    sha256 "0a956101868e56913489c8d89dc8fdb741a2bc407d432e5d86985e87f850fadb" => :sierra
    sha256 "163e473c5d766ee758cb1140c8ac3428f9a5a2cd9490983ffd1bf475b07cd8b2" => :el_capitan
    sha256 "c33275fafd72cbd3139c7e9dcbaa16f48e2f450d08e06df717700b3ca2664d34" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "openssl"
  depends_on :osxfuse

  def install
    scons "BUILDTYPE=RELEASE"
    scons "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ori"
  end
end
