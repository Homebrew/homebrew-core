class Judy < Formula
  desc "State-of-the-art C library that implements a sparse dynamic array"
  homepage "https://judy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
  sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "55191515c4d8f62b225ce9fdf49be0742d708fc8615382c77e19b1a21dee6878"
    sha256 cellar: :any,                 arm64_sequoia:  "9c845c66e4c08af1feb840119e2013109cbfba280a96022e15aa1fe703fa8c61"
    sha256 cellar: :any,                 arm64_sonoma:   "a4aae192c5fb922c184bb6468f445a680549206575f4e78a3494430234465d00"
    sha256 cellar: :any,                 arm64_ventura:  "624e8a5e7c44ff6c509097ee350f165247701cedd4fd67541fe9ca48aafad391"
    sha256 cellar: :any,                 arm64_monterey: "fb900402a39c752744d668c072a7e62fc4ad51468d2fad49dae6f49c8721e96d"
    sha256 cellar: :any,                 arm64_big_sur:  "02383b315256e97e2f0a622b94cae472765e1570442e62b13f14eeaf381c1ebd"
    sha256 cellar: :any,                 sonoma:         "61dde56d3082d456189fb9aa0beaa11c9eada260c76f12a164d23be1a9cc9965"
    sha256 cellar: :any,                 ventura:        "816a9e40b00d33093c747cb4d9c72799441d80e2992dce13630abf1e54b91572"
    sha256 cellar: :any,                 monterey:       "9c9b94476cd3939a95e1f0382c7f6a3033bc23f75e08bad7b4e68e23cce8009a"
    sha256 cellar: :any,                 big_sur:        "c353fdde22d413989196e464793606a163782bd7b14b25932f3809a84291d0d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0be75692a449169f95f155215d8e9adc714f38f486c63888ee5d6149296cb7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15200428f8b8b7ceae78d45b6b9d8a6ca48170243f3ed3d3ae80bfde4f938e15"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Regenrate configure script as it is too old for libtool patch
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <Judy.h>

      int main() {
        Pvoid_t judyArray = (Pvoid_t) NULL;
        Word_t index;
        PWord_t pValue;

        for (index = 0; index < 10; index++) {
          JLI(pValue, judyArray, index);
          *pValue = index * index;
        }

        for (index = 0; index < 10; index++) {
          JLG(pValue, judyArray, index);
          if (pValue != NULL) {
            printf("Square of %lu is %lu\\n", index, *pValue);
          } else {
            printf("Value not found for index %lu\\n", index);
          }
        }

        Word_t byteCount = 0;
        JLFA(byteCount, judyArray);
        printf("Freed %lu bytes\\n", byteCount);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lJudy", "-o", "test"
    system "./test"
  end
end
