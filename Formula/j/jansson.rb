class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "https://digip.org/jansson/"
  url "https://github.com/akheron/jansson/releases/download/v2.15.1/jansson-2.15.1.tar.gz"
  sha256 "0c7114dc0b2d22a670724a1f95922029d7077c19dbf79a584cb8084d2f267f2f"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "363280ce32ec598136c0ddeb8c2ced1fb215f9d69444acfe3d0f11ddaa00bef3"
    sha256 cellar: :any, arm64_sequoia: "f6f3e1de5cd7b36c7438f0df2ab9792ff83f829b40e23e7063735aefce9a96b7"
    sha256 cellar: :any, arm64_sonoma:  "4b84257a5dfd88b79870599b53486c60706f90d5c1031740c123732db0ea7f8e"
    sha256 cellar: :any, sonoma:        "aa40cfda276fc59d4d2142d4673f8521c36f0e25deb97a5fb8388aeb546dbeb3"
    sha256 cellar: :any, arm64_linux:   "51d8b4486d39fd4839c521110cb6abadb4c7222f7c34ba4bf3cd09289131b2cf"
    sha256 cellar: :any, x86_64_linux:  "f589a116c676bbc84a4b0628f9498080b8a05c5a89490008de69a12a7b12c548"
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
