class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.1.tar.gz"
  sha256 "4adb42fd1844a7e2ab44709dd043ade618c87f2aaec03db64f7ed659e8d3ddad"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/pdfpc/pdfpc.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "69fcafdc5492f2c38753aac0d2e146c929eeecefe7f0e7091b3a90d2463cdb46"
    sha256 arm64_big_sur:  "91b6ccda2deea3571d72dde84a374ef36be20ec5a2641b8f18ac701988e63051"
    sha256 monterey:       "7eb9b89630d7285c2b20fa0a131bec86dcf2b6a304fdea6f680949f396cd0397"
    sha256 big_sur:        "b2de1a251cd401445b171247210e1e3a729cd793eeddfe7e725039b4ea9d272c"
    sha256 catalina:       "6797e6bfdcff10e4e4b099d28547f608fbbc4aa94c0063d04b0e4d5195924f63"
    sha256 mojave:         "ceb38afd15133764d031c8abca4aabbd39fb2407bac81e0b0c0d8b9511e249cf"
    sha256 x86_64_linux:   "7f8c4bf4f879d5785c7c0832ca121e93742d82f7c03a67e3f1648028393a7d55"
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gst-plugins-good"
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DMOVIES=ON", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Gtk-WARNING **: 00:25:01.545: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "#{bin}/pdfpc", "--version"
  end
end
