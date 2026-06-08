class Libkiwix < Formula
  desc "Common code base for all Kiwix ports"
  homepage "https://github.com/kiwix/libkiwix"
  url "https://github.com/kiwix/libkiwix/archive/refs/tags/14.2.1.tar.gz"
  sha256 "cff1eb06d62ab42e1720a49f473b7d9364f02ee77a8a455c9adb26db419e0fff"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2a779996b714c51dc1df5aa842d20211e71477b04e3e7163f496967c61c65d4f"
    sha256 cellar: :any, arm64_sequoia: "f365ae439494f7c27d998ba4e875865bfe90e916c53ece33ff3b772aae685eac"
    sha256 cellar: :any, arm64_sonoma:  "5748766af7090d35b313fe2fb417d119af58d82c2f60c0d3f52189e1ce250a59"
    sha256 cellar: :any, sonoma:        "3cc3db2a4700a01f92c713ff9a3fd51d65ba2651847e1d73c79e4179a536b970"
    sha256               arm64_linux:   "10e8b84fae2fbbd98bf4edb3c26c2b2648fc208b4ba8a01bb8b94fcfb0638ddc"
    sha256               x86_64_linux:  "cc58c24a8642d767352e224a8db4f00136467fd909d7a46600147d916c6df7a7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
  depends_on "libmicrohttpd"
  depends_on "libzim"
  depends_on "pugixml"
  depends_on "xapian"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # TODO: separate as a new formula once upstream release a new tag
  resource "mustache" do
    url "https://github.com/kainjow/Mustache/archive/refs/tags/v4.1.tar.gz"
    sha256 "acd66359feb4318b421f9574cfc5a511133a77d916d0b13c7caa3783c0bfe167"
  end

  def install
    resource("mustache").stage do
      (buildpath/"mustache").install "mustache.hpp"
    end

    ENV.append_to_cflags "-I#{buildpath}/mustache"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kiwix/kiwix_config.h>
      #include <kiwix/library.h>
      #include <kiwix/manager.h>
      #include <iostream>

      int main() {
        std::cout << "libkiwix " << LIBKIWIX_VERSION << std::endl;

        // Verify Library creation and initial empty state
        auto lib = kiwix::Library::create();
        if (lib->getBookCount(true, true) != 0) return 1;

        // Parse a library XML string and verify book metadata is stored correctly
        const std::string xml = R"(
          <library version="1.0">
            <book id="test-id-001"
                  path="test.zim"
                  url="https://example.com/test.zim"
                  title="Test Book Title"
                  language="eng"
                  creator="Test Creator"
                  publisher="Test Publisher"
                  date="2024-01-01"
                  name="test_zim"
                  articleCount="42"
                  mediaCount="5"
                  size="1024">
            </book>
          </library>)";

        kiwix::Manager manager(lib);
        if (!manager.readXml(xml, true, "", true)) return 1;
        if (lib->getBookCount(true, true) != 1) return 1;

        kiwix::Book book = lib->getBookByIdThreadSafe("test-id-001");
        if (book.getTitle() != "Test Book Title") return 1;
        if (book.getCreator() != "Test Creator") return 1;
        if (book.getArticleCount() != 42) return 1;

        std::cout << "Library/Manager test passed" << std::endl;
        return 0;
      }
    CPP

    icu4c = Formula["icu4c@78"]
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test", "-I#{include}", "-I#{icu4c.opt_include}",
                    "-L#{lib}", "-L#{icu4c.opt_lib}", "-lkiwix"

    output = shell_output("./test")
    assert_match "libkiwix #{version}", output
    assert_match "Library/Manager test passed", output
  end
end
