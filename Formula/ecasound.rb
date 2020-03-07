class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "https://www.eca.cx/ecasound/"
  url "https://ecasound.seul.org/download/ecasound-2.9.3.tar.gz"
  sha256 "468bec44566571043c655c808ddeb49ae4f660e49ab0072970589fd5a493f6d4"

  bottle do
    sha256 "f6fede56fea73bdfd32cebd514448b50dec47542ff7d76342f950a61160a9fff" => :catalina
    sha256 "38869046308b12e2d722f1bcb5e9a7085ffab93448e0490b161a6d18fc2fbd09" => :mojave
    sha256 "9dd2864d7b5a66bf3a7fc674b64a11d3cb1abeaf9fc4c65dd8898a2724c1a5a8" => :high_sierra
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
