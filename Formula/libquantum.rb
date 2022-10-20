class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.0.0.tar.gz"
  sha256 "b0f1a5ec9768457ac9835bd52c3017d279ac99cc0dffe6ce2adf8ac762997b2c"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url "http://www.libquantum.de/downloads"
    regex(/href=.*?libquantum[._-]v?(\d+\.[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18cc1cd910ad5b7a0922bb290b9eb79053144d32dcd2071db5658c1e2a4e2fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d0d8ffd59105af7232222c76c283dfe0ea6c117eef683669875c9d3d4fb32cb"
    sha256 cellar: :any_skip_relocation, monterey:       "17f91015099d89946404b16a8c3eaab238ca4d9f1806942babdf4a6d1bf940a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0c15e357005695499960424b1588ce47b248eb54ba7101cd47d7b0e5427a3b4"
    sha256 cellar: :any_skip_relocation, catalina:       "d4a76e92f03a3ba478985c12c7a4d5fbe815b7b67d8a2d691eadcf43ed5eb1d6"
    sha256 cellar: :any_skip_relocation, mojave:         "437375451fc36404181dd6086f662b0305543fc8765042133706755c804c1217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a528197ff682bb96434f58a4739f933e9010f7e76b368f43d1788fe22468deb"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"qtest.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <time.h>
      #include <quantum.h>

      int main ()
      {
        quantum_reg reg;
        int result;
        srand(time(0));
        reg = quantum_new_qureg(0, 1);
        quantum_hadamard(0, &reg);
        result = quantum_bmeasure(0, &reg);
        printf("The Quantum RNG returned %i!\\n", result);
        return 0;
      }
    EOS
    args = [
      "-O3",
      "-L#{lib}",
      "-lquantum",
    ]
    args << "-fopenmp" if OS.linux?
    system ENV.cc, "qtest.c", *args, "-o", "qtest"
    system "./qtest"
  end
end
