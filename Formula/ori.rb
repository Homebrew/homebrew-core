class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.2.tar.xz"
  sha256 "a9b12ac23beaf259aa830addea11b519d16068f38c479f916b2747644194672c"
  revision 1

  bottle do
    cellar :any
    sha256 "0a281c044b4fb7daa4bb1a63cacc4b95b7723ef9b8fe9a1b2a5d9e596347336b" => :mojave
    sha256 "967376d424f8e64e4658b789beec7913db66918824454dd7082642495b19b57e" => :high_sierra
    sha256 "04595e1ffa77c8f81e0c8f9b62aeebefff42d214600e6b34ce147276d0d99bbc" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
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
