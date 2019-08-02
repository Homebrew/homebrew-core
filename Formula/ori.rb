class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.2.tar.xz"
  sha256 "a9b12ac23beaf259aa830addea11b519d16068f38c479f916b2747644194672c"
  revision 1

  bottle do
    cellar :any
    sha256 "2937393d4e11d7b6cff0f93e2ff4e9dff2357b705547efdee1bd7b653b8e1b66" => :mojave
    sha256 "9f56ea8889aa6d5e7f7bf205b1d67e26fb25929eee6e524aeb72dbbfcaec4aab" => :high_sierra
    sha256 "bdaaa086155ab57411b5b35547623f04f847eaca4478b0aebd8455f3b3d18fe2" => :sierra
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
