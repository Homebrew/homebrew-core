class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree"
  url "https://www.giuspen.com/software/cherrytree_0.99.30.tar.xz"
  sha256 "dff54e8c484beb35531a9aa0987759bc3d7e426979473ada40d1d022fdc50120"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fmt"
  depends_on "gspell"
  depends_on "gtksourceviewmm3"
  depends_on "libxml++"
  depends_on "spdlog"
  depends_on "uchardet"
  uses_from_macos "curl"

  def install
    system "cmake", ".", "-DBUILD_TESTING=''", *std_cmake_args
    system "make", "-j4"
    system "make", "install"
  end

  test do
    system "#{bin}/program", "--version"
  end
end
