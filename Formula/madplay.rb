class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/madplay[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "efd92379a16634b179ceee79023f31d6a9d2b3612acd6415fa5f40977e0fcfab"
    sha256 arm64_big_sur:  "7187cc8b51fccb528e91be3f1ccc4087c841525597cf33eb27cc8a637b3d7afc"
    sha256 monterey:       "16538130b56386dd276306aea0638ccfd4634af4dc94ff7e74fae0634d537625"
    sha256 big_sur:        "e15578875f945efd935087a951877519703c59d958217413cd52a719f9bad553"
    sha256 catalina:       "f0d2c402a824701d7ad6861ca2706701e0ba367501dcba2cb52fc27af34d6cb4"
    sha256 x86_64_linux:   "a5011a732caaaf4406c09ed7522890c84dead6c1b8257a17c63306357a5bd226"
  end

  depends_on "libid3tag"
  depends_on "mad"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6c5992c/madplay/patch-audio_carbon.c"
    sha256 "380e1a5ee3357fef46baa9ba442705433e044ae9e37eece52c5146f56da75647"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --build=x86_64
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/madplay", "--version"
  end
end
