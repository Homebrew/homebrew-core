class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "https://digip.org/jansson/"
  url "https://github.com/akheron/jansson/releases/download/v2.14.1/jansson-2.14.1.tar.gz"
  sha256 "2521cd51a9641d7a4e457f7215a4cd5bb176f690bc11715ddeec483e85d9e2b3"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f891f8b33008f64dfea6f0767ea864ac2425436416d39b6c3a138bd25956c4d"
    sha256 cellar: :any,                 arm64_sequoia: "2bc5197c2d2b866df7f529962479d0af3a81524fb84235c055d6a10ad21edd88"
    sha256 cellar: :any,                 arm64_sonoma:  "613dd35360b87dc3b327f0129ab3b0d5758b056ac1413adb5bd073a2630044b8"
    sha256 cellar: :any,                 arm64_ventura: "5d11fa69aa185323b0937cad8ed81a5159328c24acf171dd68ee5b3704c91eae"
    sha256 cellar: :any,                 sonoma:        "e79d8c86563b8ef4e9b019c7cb39c2504cdaacdaf6fbb81bfa395ed7a642fb30"
    sha256 cellar: :any,                 ventura:       "ea5ea240729d0dfd637dfee2d14fab5b047301b8a062d44a8d78597351e0aeaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b915682e024ec87c583bf32398fb164a3978dbe2f7b6512fa9b8e684bac76c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a841f8b0d0f57190fc62c0045e42b6e38a321ebe1949607e5771ef71b20aaf21"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <jansson.h>
      #include <assert.h>

      int main()
      {
        json_t *json;
        json_error_t error;
        json = json_loads("\\"foo\\"", JSON_DECODE_ANY, &error);
        assert(json && json_is_string(json));
        json_decref(json);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ljansson", "-o", "test"
    system "./test"
  end
end
