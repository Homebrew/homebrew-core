class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"

  bottle do
    sha256 "06320361fe8d3687b541149a2c26f78b9a251a813ef7ca1ecfe09e6dfd7ec1b9" => :catalina
    sha256 "04339d670f10b87819965e4bae0e5700840e97e1052313cc62dd5ae6d7e194ce" => :mojave
    sha256 "7ff11d9521cb9507f669753e8c862efa44f5673cc009578202c1ec7dcba379d1" => :high_sierra
    sha256 "a4a1b057547c65f8d793e874632e98ee10bfdae234ff011d16d99593c3fa7853" => :sierra
    sha256 "81dbc8781c5da50f7188a4031ed5d500b07c51a7589da6799c6bf3477bb90bf6" => :el_capitan
    sha256 "4ab0b6303cafe408494e85c38b80a3c44964953995c024d2b65a019bc5608c05" => :yosemite
    sha256 "2b1967955d83ca172724b119e837457aec0eeaa7ded354c810f3635dafbec057" => :mavericks
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
