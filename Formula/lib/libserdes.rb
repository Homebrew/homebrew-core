class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.0.0",
      revision: "152fad7ddec001e886452726e71f3b6a5c8e8c65"
  license "Apache-2.0"
  revision 1
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d14c0904a6396fc3b7d63bff0fac59cdbaa5c30f6f758df178125e1dcb6b821"
    sha256 cellar: :any,                 arm64_sequoia: "319bea2747221a48f11a7c3d6e8363793610293f32404bbd91dc2eb61f7b6dd1"
    sha256 cellar: :any,                 arm64_sonoma:  "7e614941c2920db28479be0d9854510739862a5b40caaa8529d4c876f1c2e5ff"
    sha256 cellar: :any,                 arm64_ventura: "7ed196b9eea5699f8f4df9e45111f01ee30685b558e980100a77d9ec8705eabe"
    sha256 cellar: :any,                 sonoma:        "76d1e59097226848b086b01c595f3a66434c0274ef39affd0b10e82be1a50d78"
    sha256 cellar: :any,                 ventura:       "14bea0c4c0988ddc6d113f9ac1299125f3ae045bf4816750f4ade018ae30edf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1d696270184609077865420700b402e977fba0e81252ff0876bdc27f54f288e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2c24fafc2c911f512bc7b4e96f4eb5ee86992539a7a021fbc2b85874deffb48"
  end

  depends_on "avro-c"
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <err.h>
      #include <stddef.h>
      #include <sys/types.h>
      #include <libserdes/serdes.h>

      int main()
      {
        char errstr[512];
        serdes_conf_t *sconf = serdes_conf_new(NULL, 0, NULL);
        serdes_t *serdes = serdes_new(sconf, errstr, sizeof(errstr));
        if (serdes == NULL) {
          errx(1, "constructing serdes: %s", errstr);
        }
        serdes_destroy(serdes);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system "./test"
  end
end
