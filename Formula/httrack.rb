class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.49.2.tar.gz"
  sha256 "3477a0e5568e241c63c9899accbfcdb6aadef2812fcce0173688567b4c7d4025"
  revision 1

  livecheck do
    url "https://mirror.httrack.com/historical/"
    regex(/href=.*?httrack[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 arm64_monterey: "c5a4b83c1114034b3f51ad5d906d6e4f984afd7696089062183ede4281ed1700"
    sha256 arm64_big_sur:  "e33695d628a65bb1c6a5bb5f1147ea4560f8881482e60e10f0a8837527153609"
    sha256 monterey:       "b8e82f9c6ad3e8011d5551553b4866752d12929994b36cdcd8128e69cacda3d6"
    sha256 big_sur:        "2f773ea2f9bdf0234abee17e9bd2003f21396fe1fdda756dd6e4faf7844f9c01"
    sha256 catalina:       "291ab06b376233166dd833422801d0a7be6f06cdabdc568656ec64ad3adc5fe8"
    sha256 mojave:         "6e0d2265e15d103a37b6b594f7f10c85af82012f1e3c1e25fc436e7430502b2c"
    sha256 high_sierra:    "612d8c3f9ee15fd7c4f42dbca3c5e3b58e968d626aa15f916f85c8cdb44ea31f"
    sha256 sierra:         "842d48bdb72573623a478a97a2c2abcafe34fb4b0443229216e35d30552dd27f"
    sha256 x86_64_linux:   "cf514800be63c284276aa19e44b7d6822b182166a64b8ceb45dd96c4818504ee"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_predicate testpath/"raw.githubusercontent.com", :exist?
  end
end
