class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "63f070c19c97ce4d5dfcbc1fa8cc5237d4c9decf39341a31188dbdceef93b542"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8491417d63146236b5e5d177bafb22e74e034ac69111304780e5cd80fd88f951"
    sha256 cellar: :any,                 arm64_sequoia: "4e27e0ca5fb832bede40cb674a8ee9ae926022f871b5e3326d8995f2cdfe0e45"
    sha256 cellar: :any,                 arm64_sonoma:  "dcbbb7ba5979abc42d4d0ca5b0ce7b648f34ea9ca95baa82172e7d7a5371c34f"
    sha256 cellar: :any,                 arm64_ventura: "9f95beb82c8c18f6184cae82bf0a7dc8d52bf32a63c0476fc792618b09ae261f"
    sha256 cellar: :any,                 sonoma:        "ef8f4ba9ae19ad48989abf3d45abb97d6761d2d6cd1eedf22a20cb4a2f9fb67a"
    sha256 cellar: :any,                 ventura:       "ccb6907d6c8974fc7bb7b8c05ee8b777da02281694a5ce1c207543bdbc1d1234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba61fe86e05fbd61a1f35a136e8d83def7a9c705cf40acd815ce0f32b7702d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71bfc43a1abfa03e8c40318a276d52672fcabeee77f63ea03939832249c7df0d"
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
