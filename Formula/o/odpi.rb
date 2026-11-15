class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v26.0.0.tar.gz"
  sha256 "419cc5d64ad052261244a818d40beb135ce147480f9ef19acc105eba8a96d60d"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "759eebe0edadea88f62029d9e5287b0daf8674abeb15ba7ae9d64cd79781e1b3"
    sha256 cellar: :any, arm64_tahoe:       "b020a00d87b5b941c0f1ba21c22e102d04dc2cdef399592d8ab86f7c4a846900"
    sha256 cellar: :any, arm64_sequoia:     "8dc576534dab1871cd3fb26dcbd7bbe960beff17a783a4efdc49c0da3c2f2303"
    sha256 cellar: :any, arm64_sonoma:      "31e20f8e616d7ad704ca4ae89311ea297c46fffe2bb408948f1f3625cad3d20b"
    sha256 cellar: :any, arm64_linux:       "db60e8b503ddc669a15515c4ca1be06f46c15a9df91e49cf7216c79762db8b4a"
    sha256 cellar: :any, x86_64_linux:      "73c932c1db34d7375dbc3ea6666d3b93adda722b236d138c8ef83d22b440d8ea"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
