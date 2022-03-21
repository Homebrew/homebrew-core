class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://github.com/libwbxml/libwbxml"
  url "https://github.com/libwbxml/libwbxml/archive/libwbxml-0.11.8.tar.gz"
  sha256 "a6fe0e55369280c1a7698859a5c2bb37c8615c57a919b574cd8c16458279db66"
  license "LGPL-2.1"
  head "https://github.com/libwbxml/libwbxml.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a2513915ab52a7d38cd5ce8ad692687a73c4d236b9d76003cc5c73d02283f8f7"
    sha256 cellar: :any, arm64_big_sur:  "eb325fe7f67e3c16920d8b76683f7571805c6cf86dd07c386c771a5484e5a0c9"
    sha256 cellar: :any, monterey:       "a102e703053750d123cc5efe890bd8172ff8a64110ea4c1eb0fa882b61da8fe6"
    sha256 cellar: :any, big_sur:        "4b43949c7ee441bfcc19bc6cdac54a1264f5343d5179aca233df6e07eba08079"
    sha256 cellar: :any, catalina:       "66499727f77c70556d1e89ab37d42bfaa4737527808ac15199174dafd08917c9"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "wget"

  uses_from_macos "expat"

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/",
                                      "#{share}/cmake/Modules"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_DOCUMENTATION=ON",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end
end
