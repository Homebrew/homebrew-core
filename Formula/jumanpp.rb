class Jumanpp < Formula
  desc "Japanese Morphological Analyzer based on RNNLM"
  homepage "https://nlp.ist.i.kyoto-u.ac.jp/EN/index.php?JUMAN%2B%2B"
  url "https://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.02.tar.xz"
  sha256 "01fa519cb1b66c9cccc9778900a4048b69b718e190a17e054453ad14c842e690"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?jumanpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e9b65ec6cbc79b48a403d5a9c30a59eedfe9cb412be6a4d6ccf65f653e96e8d4"
    sha256 big_sur:       "9c97f442fdad1ae3ab776ef16de98876db768134d50235e9ea683579fa8a85b7"
    sha256 catalina:      "4b2c208b0954536aa3f2b838a525e2542a547a192a03951c0f8a7f69c082a60d"
    sha256 mojave:        "248e639859582dcf3613eb4eaf491e5ada0ed527e89595d6ba110219e8f8ab28"
    sha256 high_sierra:   "87555f0efa065cd86d3344c8304972567d4b8a84ef1c0e53acb09afabbd1fa9e"
    sha256 sierra:        "afddd3445d86fa1969611b413d0ae460fdaa7b106cdf5edf6ce0bf9d14689a49"
    sha256 el_capitan:    "4b4dd5ca55ba7d380a9a6bc7dda462c3825aa8650e9dc6b131e53fadbf64dc63"
    sha256 yosemite:      "d53d25e49f4bd8cddd2657ee09eeaec56844996b10445c15561be1a12977a888"
    sha256 x86_64_linux:  "a646201910dc5c938adcd64559fc0ce85dd8f13017ddadb1b65965f4cc2f4afe"
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

    output = <<~EOS
      こんにち こんにち こんにち 名詞 6 時相名詞 10 * 0 * 0 "代表表記:今日/こんにち カテゴリ:時間"
      は は は 助詞 9 副助詞 2 * 0 * 0 NIL
    EOS

    assert_match output, pipe_output(bin/"jumanpp", "echo こんにちは")
  end
end
