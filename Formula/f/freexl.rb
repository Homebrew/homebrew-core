class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-2.0.0.tar.gz"
  sha256 "176705f1de58ab7c1eebbf5c6de46ab76fcd8b856508dbd28f5648f7c6e1a7f0"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{current version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a3eeadb863696639ca30ce87c4f27b4afda4389b705423244abfd83f3479a5e0"
    sha256 cellar: :any, arm64_sequoia: "9fdcbb2c4a1ea545ed78a6587928e08f4805046aa01ffe56101c6efe2957be9f"
    sha256 cellar: :any, arm64_sonoma:  "aed9e170181526ad9b827249bbcc5a862faa81d8851dcd680127e5734b27390b"
    sha256 cellar: :any, sonoma:        "626d351bf6af78205d0dff5219d9c5f1a7c26e75b35a7f1065c348ab21478f1d"
    sha256 cellar: :any, arm64_linux:   "5e09ca900e02e38d7402c3575de5dc70efaf841e6bee050ff1f4050301a2a971"
    sha256 cellar: :any, x86_64_linux:  "1d0329fc0248619e9702b70d4d64ea78597aa90b471da082388560447a957778"
  end

  depends_on "minizip"

  uses_from_macos "expat"

  def install
    args = ["--disable-silent-rules"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "freexl.h"

      int main()
      {
          printf("%s", freexl_version());
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lfreexl", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
