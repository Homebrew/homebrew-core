class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v5.0.1.tar.gz"
  sha256 "e12a1053ac13de9065a1011f51a6fb1f86281756fb997150bb69c8e91fb9b640"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a89c151693b06a33a14195d3aa2aa4a5a5fd39918ccaa99f735f20b1d787d60a"
    sha256 cellar: :any,                 arm64_ventura:  "4a960be0f459c2cccd1490c3176f98f589d88226c613a8e6bc272592b6a993f3"
    sha256 cellar: :any,                 arm64_monterey: "78df68a122e9f976e5dd815ea34208efbed8a7fc1a2d12f522c7efe7607a7f20"
    sha256 cellar: :any,                 sonoma:         "3ebeb43452ae60fd4b065dd069ae7ad98ec983fceec0c48abb0cfbb699e8f8cc"
    sha256 cellar: :any,                 ventura:        "3b9060e9ae8c6576895711dc222c78d9669cd6e8bbfa7b6d02e0b8e0af7aca52"
    sha256 cellar: :any,                 monterey:       "d78b6d7db88ca35e5dee4ff7168a007ecd4f147bc2379818bba6fa6db101546c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47539eeeb7b77a7d352e3de3f372d809a05e993ae784ab95421b22e075654f28"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
