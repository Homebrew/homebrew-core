class Libkiwix < Formula
  desc "Common code base for all Kiwix ports"
  homepage "https://github.com/kiwix/libkiwix"
  url "https://github.com/kiwix/libkiwix/archive/refs/tags/14.2.0.tar.gz"
  sha256 "244b69120d132de3079774ee439f9adfb7b556e88b9ef6ce5300f37dfc3737bc"
  license "GPL-3.0-or-later"

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

  # Mustache header-only library (required dependency)
  resource "mustache" do
    url "https://github.com/kainjow/Mustache/archive/refs/tags/v4.1.tar.gz"
    sha256 "acd66359feb4318b421f9574cfc5a511133a77d916d0b13c7caa3783c0bfe167"
  end

  def install
    # Install Mustache header
    resource("mustache").stage do
      (buildpath/"mustache").install "mustache.hpp"
    end

    # On macOS, CLT 17+ moved C++ stdlib headers into the SDK; pass them explicitly so
    # meson's atomics check can find <atomic> when configuring.
    # Also pass mustache include path via cpp_args so meson's has_header check finds it.
    extra_cxx_args = ["-I#{buildpath}/mustache"]
    if OS.mac?
      sdk_cxx_include = MacOS::CLT.sdk_path/"usr/include/c++/v1"
      extra_cxx_args << "-isystem#{sdk_cxx_include}" if sdk_cxx_include.exist?
    end

    system "meson", "setup", "build",
                    "-Dcpp_args=#{extra_cxx_args.join(" ")}",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kiwix/kiwix_config.h>
      #include <iostream>
      int main() {
        std::cout << "libkiwix " << LIBKIWIX_VERSION << std::endl;
        return 0;
      }
    CPP

    # Get icu4c path for compilation
    icu4c = Formula["icu4c@78"]

    cxx_args = ["-std=c++17", "-I#{include}", "-I#{icu4c.opt_include}",
                "-L#{lib}", "-L#{icu4c.opt_lib}", "-lkiwix", "-o", "test"]
    if OS.mac?
      sdk_cxx_include = MacOS::CLT.sdk_path/"usr/include/c++/v1"
      cxx_args = ["-isystem#{sdk_cxx_include}"] + cxx_args if sdk_cxx_include.exist?
    end
    system ENV.cxx, "test.cpp", *cxx_args

    assert_match "libkiwix #{version}", shell_output("./test")
  end
end
