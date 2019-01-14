class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tgz"
  sha256 "a6dd5677608c81d8cda657eb330661b5f9e0957a962a5588473d556ddf49f15f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "2c40de6a29e9aa747f6370b93122a437c8ff3e35fd93129141b467ad18414894" => :mojave
    sha256 "d96b3f8a41b879772d0b2e3f9eff4e43c73cb268b782c0ddbbdd82bd9680d804" => :high_sierra
    sha256 "3851019914d6ea9efc9115c100b73d24775b6d5d6c517399aea4259e74097670" => :sierra
    sha256 "c19677cd17c419810b6389aa7c2815f0f8da16d7035dbdad5e209a96913e1f45" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost@1.60"
  depends_on "libevent"
  depends_on "openssl"
  depends_on :osxfuse

  def install
    system "scons", "BUILDTYPE=RELEASE"
    system "scons", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ori"
  end
end
