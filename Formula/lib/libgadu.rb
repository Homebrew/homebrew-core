class Libgadu < Formula
  desc "Library for ICQ instant messenger protocol"
  homepage "https://libgadu.net/"
  url "https://github.com/wojtekka/libgadu/releases/download/1.12.2/libgadu-1.12.2.tar.gz"
  sha256 "28e70fb3d56ed01c01eb3a4c099cc84315d2255869ecf08e9af32c41d4cbbf5d"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "879445863308113193c508342b36698ecdf0d0e5f44f3844458429283d8a1c17"
    sha256 cellar: :any,                 arm64_sequoia: "faad50d22aae75f047e8a3bbf4241ca918cad6808e306400123af10e820902f9"
    sha256 cellar: :any,                 arm64_sonoma:  "3e6826d330db02d16c49436a862860afb6da95c2b2dd32506a090954d284a643"
    sha256 cellar: :any,                 sonoma:        "199ce413350e6e9544e2bdc1ae6bc7c485ea0344340b13892388daaf2a2f5215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61f21d773a75489c8f69d2ab1430995e724b04025e4273e68f3fea8e2fc1dfe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5899baf91f55702652d744655613adb2c276e48c8f300b93fd52993ae4cc58"
  end

  deprecate! date: "2026-02-20", because: :repo_archived
  disable! date: "2027-02-20", because: :repo_archived

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--without-pthread", *std_configure_args
    system "make", "install"
  end
end
