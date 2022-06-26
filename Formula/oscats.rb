class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_monterey: "b1b79b163aa6caf6bda95defe34d5ea891c5cec0e134d02aea71c9d9939d3af8"
    sha256 cellar: :any, arm64_big_sur:  "06cc3ac71a633a0588edcc8a61872660ef33f5301949eb73c2796feeb7994d9f"
    sha256 cellar: :any, monterey:       "da984e6f108145570e8acf10797c2cf779d2d99368f8863c4deb53048c24cf1c"
    sha256 cellar: :any, big_sur:        "8e8832be92d504b671f833b993ffa5f00b40cea7af1c41fea910d54f5fb4ed7b"
    sha256 cellar: :any, catalina:       "cb2266d78836d4aa751eca4eeaed96e6df7fbe160fb9a0a996f4eb9dfa3eacc1"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gsl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
