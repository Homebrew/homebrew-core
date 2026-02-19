class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.6.4.tar.gz"
  sha256 "d8ba665d9deb0f0c601e38de477d3808e7d426438b9e37345bef53f0e75687ea"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a6676b58158a1c7d3748565cc3db376b66aea0172f0a1507843a13f4c4a376c"
    sha256 cellar: :any,                 arm64_sequoia: "ce314efcbe39364995d9ef2b88f145f81c1648914d5d53a374d9f76c0d03c95b"
    sha256 cellar: :any,                 arm64_sonoma:  "09803feb041abef5738b31b18350f5e4551947e7b3960170f48671e10a6423a6"
    sha256 cellar: :any,                 sonoma:        "cbe010ec61585e5b0559f9694001c7f2953d9c5267232ce746fdecc33b858383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69f242660d2cea8f4ada128a8a7204dfb7595d354cf07a1ba8fa33c46c6e52dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d442d47435cba91054e84e264668f7a55be6a2c3c07618da5671d649fb7a6fc8"
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
