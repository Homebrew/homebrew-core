class Cherrytree < Formula
  desc "A hierarchical note taking application, featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree"
  url "https://www.giuspen.com/software/cherrytree_0.99.30.tar.xz"
  sha256 "dff54e8c484beb35531a9aa0987759bc3d7e426979473ada40d1d022fdc50120"
  license "GPL-3.0+"

  depends_on "python3" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtksourceviewmm3"
  depends_on "gnome-icon-theme"
  depends_on "gspell"
  depends_on "libxml++"
  depends_on "curl"
  depends_on "uchardet"
  depends_on "fmt"
  depends_on "spdlog"

  def install
    system "cmake", ".", "-DBUILD_TESTING=''", *std_cmake_args
    system "make", "-j4"
    system "make", "install"
  end

  test do
    system "#{bin}/program", "--version"
  end
end
