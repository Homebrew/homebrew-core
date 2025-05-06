class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8ab0aced8a6e82f12f567b48d2cb3ca7b925893126607a619666da467e9ac14f"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b03fecbf3ece1bcc03a87c89a84f60fa73b7e0b119d257c477fdc11d4acf188"
    sha256 cellar: :any,                 arm64_sonoma:  "b02767c87f8db4bc8eecf747a9c8ea80db9dfadf4ad330b835f09317e038d2b9"
    sha256 cellar: :any,                 arm64_ventura: "6382eb17ff04a5e5871c07bd400bbeb796b39a0825f617481428ecb96a0547e5"
    sha256 cellar: :any,                 sonoma:        "50f6b2f9e3133fd947fc072a10bc180878a830a9dd950091bef325ecfb7001fd"
    sha256 cellar: :any,                 ventura:       "f27ed6a59bc16de11c207ac54d51a403aaee52890ac0d00b0a8b98e65330e42f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db67a2e2c9e7234d96e833866631dbeb778f6d235f852e92b452a6fc22d487bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6acbfaa5bc5479bd3b91fb788b50117e638d4c86699876cac937d415fc2ca06"
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system "./test"
    assert_path_exists testpath/"myexcel.xlsx", "Failed to create xlsx file"
  end
end
