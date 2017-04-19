class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tgz"
  sha256 "a6dd5677608c81d8cda657eb330661b5f9e0957a962a5588473d556ddf49f15f"
  revision 1

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
