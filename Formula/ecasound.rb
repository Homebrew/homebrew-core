class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "https://www.eca.cx/ecasound/"
  url "https://ecasound.seul.org/download/ecasound-2.9.2.tar.gz"
  sha256 "c14991dfc77eb5f7e3851aaeaf71290b21dcd451b65c63b4db8e0bec90d02c97"

  bottle do
    rebuild 1
    sha256 "6166bd8bfe46c9cd397ebbdd309228ebdaf4ba85be03b3b5190ee85a78a149c9" => :mojave
    sha256 "b0d1ebfd5db18a8141c0a9ddc9a9a62f155d4db16d6f68e7162cd9cf27a0a02d" => :high_sierra
    sha256 "fe062d9a9f6c5072c2a6dd8778c1fd842694e43fb91dede0f877628a2d8eb27f" => :sierra
  end

  depends_on "jack"
  depends_on "libsamplerate"
  depends_on "libsndfile"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-rubyecasound=no
      --enable-sys-readline=no
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.wav")
    system bin/"ecasound", "-i", "resample,auto,#{fixture}", "-o", testpath/"test.cdr"
    assert_predicate testpath/"test.cdr", :exist?
  end
end
