class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  # The upstream homepage was "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/"
  homepage "https://salsa.debian.org/debian/lv"
  url "https://salsa.debian.org/debian/lv/-/archive/debian/4.51-9/lv-debian-4.51-9.tar.gz"
  sha256 "ab48437d92eb7ae09e22e8d6f8fbfd321e7869069da2d948433fb49da67e0c34"
  license "GPL-2.0-or-later"
  head "https://salsa.debian.org/debian/lv.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "5b5dd9f26574075bc3d95ee8471eb88bc1bc7158d6f5172876762987b5bf0cda"
    sha256                               arm64_sonoma:  "3cd056cc510f5adfcac3704dd51714f19d8766be53775f91e6a5fe7911ca2e9f"
    sha256                               arm64_ventura: "12db89933a9d1da2d4cbcd46eedfe8a012daceee73f3aa2847633250c622a48d"
    sha256                               sonoma:        "5b09e7911cc65d1973481307932fd0bb6b17d2a05c6826c0ae544cbb3501987e"
    sha256                               ventura:       "406d582f716e59c5da1ffaf83e36ccbdcf7fb94f29641f2e5bd1faff4ad1bd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cca7e45af8674ea0900398f58a2df15116ad78bc37cd16606f8438722dfd599"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "gzip"
  end

  # See https://github.com/Homebrew/homebrew-core/pull/53085.
  # Being proposed to Debian: https://salsa.debian.org/debian/lv/-/merge_requests/3
  patch :DATA

  def install
    File.read("debian/patches/series").each_line do |line|
      line.chomp!
      system "patch", "-p1", "-i", "debian/patches/"+line
    end

    if OS.mac?
      # zcat doesn't handle gzip'd data on OSX.
      # Being proposed to Debian: https://salsa.debian.org/debian/lv/-/merge_requests/4
      inreplace "src/stream.c", 'gz_filter = "zcat"', 'gz_filter = "gzcat"'
    end

    cd "build" do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install "lv"
      bin.install_symlink "lv" => "lgrep"
    end

    man1.install "lv.1"
    (lib+"lv").install "lv.hlp"
  end

  test do
    system bin/"lv", "-V"
  end
end

__END__
--- a/src/escape.c
+++ b/src/escape.c
@@ -62,6 +62,10 @@
 	break;
     } while( 'm' != ch );
 
+    if( 'K' == ch ){
+        return TRUE;
+    }
+
     SIDX = index;
 
     if( 'm' != ch ){
