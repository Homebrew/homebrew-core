class Libkiwix < Formula
  desc "Common code base for all Kiwix ports"
  homepage "https://github.com/kiwix/libkiwix"
  url "https://github.com/kiwix/libkiwix/archive/refs/tags/14.2.1.tar.gz"
  sha256 "cff1eb06d62ab42e1720a49f473b7d9364f02ee77a8a455c9adb26db419e0fff"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e1d04dffbd54f59317d6da825cd0d61f59c212fde33a53e8bae3576bfc78d1c"
    sha256 cellar: :any, arm64_tahoe:       "f32925d681d9b06efcc3294fc75589aecf814500c111f3fa734b7f05f6fc2934"
    sha256 cellar: :any, arm64_sequoia:     "930af927b39e421dca7198e4321af5c1ab046ccd2153b7149231f828d0033ffd"
    sha256 cellar: :any, arm64_linux:       "6d08d70889893f69ed0ce636bd4f6d96ff48fcab00cd08fda2dc87206d3206ac"
    sha256 cellar: :any, x86_64_linux:      "790ec4d64537b29fde3d13bfed4f39d7833812602536600c6aa5c478d11ded64"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@79"
  depends_on "libmicrohttpd"
  depends_on "libzim"
  depends_on "pugixml"
  depends_on "xapian"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

    icu4c = Formula["icu4c@79"]
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test", "-I#{include}", "-I#{icu4c.opt_include}",
                    "-L#{lib}", "-L#{icu4c.opt_lib}", "-lkiwix"

    output = shell_output("./test")
    assert_match "libkiwix #{version}", output
    assert_match "Library/Manager test passed", output
  end
end
