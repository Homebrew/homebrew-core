class Jumanpp < Formula
  desc "Japanese Morphological Analyzer based on RNNLM"
  homepage "http://nlp.ist.i.kyoto-u.ac.jp/EN/index.php?JUMAN%2B%2B"
  url "http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.02.tar.xz"
  sha256 "01fa519cb1b66c9cccc9778900a4048b69b718e190a17e054453ad14c842e690"

  bottle do
    sha256 "0d7b87ef8e8e2321c4e6ae7adc54421be07ed062387bd251d2d52103496eb66d" => :sierra
    sha256 "78ca20518d546df4bdc16c759a304b85b94e0f3a21d081446f2c122d76bc3121" => :el_capitan
    sha256 "522b6b6a9bade9082d131a0be2c852d9cb80aa99635265e87e54b98b91769b33" => :yosemite
  end

  depends_on "boost-build" => :build
  depends_on "boost"
  depends_on "gperftools"

  patch do
    # This problem is resolved on upstream: https://github.com/ku-nlp/jumanpp/commit/4cabe0fb0ff28d0176a11f40b959e224eccc541e
    # After 1.02 will be released, this patch should be removed.
    url "https://gist.githubusercontent.com/chezou/076cb9c407de729ad2e2d04749f07f3e/raw/8115a2dfca48e9f9f5aee12cea39377238c5110f/jumanpp-Makefilein.patch"
    sha256 "f7a2b222ea74625d9ccfe62d61d2808a828669463b6cad509aef95de7537ebc9"
  end

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
