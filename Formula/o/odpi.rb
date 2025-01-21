class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "dc02c694e119c69af3a556a363fe406b26996d0e71c4c5dfbf9d7a253efa6a01"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e033b3bfed34e7ce44609b3246b5b75ce04621ceafb68c82ae9758134d05ac3f"
    sha256 cellar: :any,                 arm64_sonoma:  "04932f05827d04407bb99ee961060445a636baedc214d17f70f5efa759a34fcb"
    sha256 cellar: :any,                 arm64_ventura: "04eb6b6c23351da490655c6978a4b966e567016e5c58228b92da7392cbf7a7c0"
    sha256 cellar: :any,                 sonoma:        "305575b63b5f0eb78f083f62e678a5c1519544a53e43a71251646ef165bbae93"
    sha256 cellar: :any,                 ventura:       "4d22a8140a6eb018972ce42d5496a6216c0c30b07f57239c88dde4fd740a4092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab4874e0519e7b7382a63acdb19334f6a3148345330ded22b5851a4ef5b8a7d0"
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
