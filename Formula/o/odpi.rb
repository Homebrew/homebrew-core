class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "cccb2a6c2e6e5510095a33a3329929aa4a74477a3816b3e7327a3e71ceff9118"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "205136b93c6139fc76e9f81ad2e80437e0bdd0a4811928b0c8f1ea5e70208e00"
    sha256 cellar: :any,                 arm64_sonoma:  "0fdee06177f56ae9fb9b5c031a542ddd37d829712ddecff6d8b8ef86b19f7f43"
    sha256 cellar: :any,                 arm64_ventura: "663fc84d64b0bf2ec93833dc83e3bb39e186ccd2e441c8058a79190ee159a5a2"
    sha256 cellar: :any,                 sonoma:        "0d2c5e33d13ff8df81409ad7de92fa98c5f67af313b43bd3afd08e66638a5592"
    sha256 cellar: :any,                 ventura:       "56553ba8e170a0ef75457bba30a8a1e8138c02109dbe3fd5e4c72a502b5f92b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1b9405a8dc474e979684120bd2823c45a95efca8bbba39569d403cd41170d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b82f176dcff652923fc295bed47ff9412f8791a071397d7044d5b9273538c41"
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
