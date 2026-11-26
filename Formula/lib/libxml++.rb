class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/5.6.1/libxml++-5.6.1.tar.xz"
  sha256 "4996e8a73995e8a4cd656c8591dce38181146edfc30cb47c97d1db3c56990ad7"
  license "LGPL-2.1-or-later"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(\d+\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    manifest_sha256 "3feabad3c0f0bc7e2fb7604c378f5faa0809fc48518eddf195378346f3463cf2"
    sha256 cellar: :any, arm64_golden_gate: "182c9944a6023fef0dcda471ac25cc29ed09310e7c05011b96a75d77de9a9a20"
    sha256 cellar: :any, arm64_tahoe:       "fdbe9557488a16846189d4f49654a169871088fa73f86bd3812e3432dc4e7763"
    sha256 cellar: :any, arm64_sequoia:     "487793daf95de7fef460f9061699e69789992630305506a29ce9a5c76f4a5624"
    sha256 cellar: :any, arm64_linux:       "f1e371fbb6d89963a1f98a363c7b0d54f548c799ed233c6a989dff0c4a83e182"
    sha256 cellar: :any, x86_64_linux:      "09494a8837bf85f1d5369e80809b146cc6f59f76ff06249322aef76648da5d51"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    CPP
    command = "#{formula_opt_bin("pkgconf")}/pkgconf --cflags --libs libxml++-5.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
