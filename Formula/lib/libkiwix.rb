class Libkiwix < Formula
  desc "Common code base for all Kiwix ports"
  homepage "https://github.com/kiwix/libkiwix"
  url "https://github.com/kiwix/libkiwix/archive/refs/tags/14.2.1.tar.gz"
  sha256 "cff1eb06d62ab42e1720a49f473b7d9364f02ee77a8a455c9adb26db419e0fff"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1a163b339857896a25e7ca137ea5b89b9e694b373504ff96e4c0ce54571cb415"
    sha256 cellar: :any, arm64_sequoia: "39923d9fa6b7814243a0f16bde23b4748f8a22d6700b1b3e60a522e603bd2a53"
    sha256 cellar: :any, arm64_sonoma:  "f1459f38b2a666ee732745d1b3f721387effe6eabac795d9032787268f29255a"
    sha256 cellar: :any, sonoma:        "36b65cfdc8f4a14eec5306166e155ad619ae44daa3fe82d55294978fd7e0b221"
    sha256               arm64_linux:   "7136c54709fc11a9c35aa4ad5ca1935eb99decbb4cbc534ab09ce9a9d0935378"
    sha256               x86_64_linux:  "6757a377743d2dd7fc5a7a51872dad662f04e2448d5ad313a2e46bf883f44024"
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

    icu4c = Formula["icu4c@78"]
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test", "-I#{include}", "-I#{icu4c.opt_include}",
                    "-L#{lib}", "-L#{icu4c.opt_lib}", "-lkiwix"

    output = shell_output("./test")
    assert_match "libkiwix #{version}", output
    assert_match "Library/Manager test passed", output
  end
end
