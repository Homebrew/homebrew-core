class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "https://www.eca.cx/ecasound/"
  url "https://ecasound.seul.org/download/ecasound-2.9.2.tar.gz"
  sha256 "c14991dfc77eb5f7e3851aaeaf71290b21dcd451b65c63b4db8e0bec90d02c97"

  bottle do
    sha256 "1968bbbd93c0a1b0e9d4a69c983993f8449af6dc9b4ec11771509b9448fddaa0" => :catalina
    sha256 "9bd0c3a15f5efa4ac0a97350ac54ea363ccca4b6d213dc961d8490276a69552a" => :mojave
    sha256 "e9f0021e07723fc2e5a4d4cb3b5a27cecafd52fefce3255c488183122d0d718d" => :high_sierra
    sha256 "05131605c2721fe09dca3699c9662d2dec290f8640a6e3daef1d2ac84b9f51d4" => :sierra
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
