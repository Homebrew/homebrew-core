class Jumanpp < Formula
  desc "Japanese Morphological Analyzer based on RNNLM"
  homepage "http://nlp.ist.i.kyoto-u.ac.jp/EN/index.php?JUMAN%2B%2B"
  url "http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.02.tar.xz"
  sha256 "01fa519cb1b66c9cccc9778900a4048b69b718e190a17e054453ad14c842e690"

  bottle do
    sha256 "afddd3445d86fa1969611b413d0ae460fdaa7b106cdf5edf6ce0bf9d14689a49" => :sierra
    sha256 "4b4dd5ca55ba7d380a9a6bc7dda462c3825aa8650e9dc6b131e53fadbf64dc63" => :el_capitan
    sha256 "d53d25e49f4bd8cddd2657ee09eeaec56844996b10445c15561be1a12977a888" => :yosemite
  end

  depends_on "boost-build" => :build
  depends_on "boost"
  depends_on "gperftools"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["LANG"] = "C.UTF-8" # prevent "invalid byte sequence in UTF-8" on sierra build
    system bin/"jumanpp", "--version"

    output = <<-EOI.undent
      こんにち こんにち こんにち 名詞 6 時相名詞 10 * 0 * 0 "代表表記:今日/こんにち カテゴリ:時間"
      は は は 助詞 9 副助詞 2 * 0 * 0 NIL
      EOS
      EOI

    assert_match output, pipe_output(bin/"jumanpp", "echo こんにちは")
  end
end
