class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.2.tar.xz"
  sha256 "a9b12ac23beaf259aa830addea11b519d16068f38c479f916b2747644194672c"
  revision 2

  bottle do
    cellar :any
    sha256 "7a7309ce9c2910c06ef1e1476ab733f72b561914e8fbac72fde592aef0e319e2" => :catalina
    sha256 "2dc4c7383255f7d3abd165745afd4430aceb307448d2f7798cc2674697503e02" => :mojave
    sha256 "181896615606cbb6a43a8d9cc5380290985c70c839d579db434c3cdf1e0d4582" => :high_sierra
    sha256 "7808e13ef9dd8a689053855d6efbdfbed0e474d1474ac981e67d3aa9f75a0d6f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on :osxfuse

  # Patch adapted from upstream for OpenSSL 1.1 compatibility
  # https://bitbucket.org/orifs/ori/pull-requests/7/adjust-to-libssl-api-changes-from-10-to-11/diff
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/ori/openssl-1.1.diff"
    sha256 "234448ebdf393723fb077960e66c3f5768c93989f9d169816f17600ef64e8219"
  end

  def install
    system "scons", "BUILDTYPE=RELEASE"
    system "scons", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ori"
  end
end
