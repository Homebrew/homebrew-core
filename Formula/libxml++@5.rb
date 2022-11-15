class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/5.0/libxml++-5.0.2.tar.xz"
  sha256 "7c17cc3e5a2214314dee5a1354f4b436f266ded6185232a0534f352a76240d5a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a0a175d17f147bbb84833ef4d68817287eca7f06727b079db2bff59fa68c4dac"
    sha256 cellar: :any,                 arm64_monterey: "9421a78d289abe9cbe85aae2d4b35be65d3cdc142f6c7fce8fc5e5e1d29ae747"
    sha256 cellar: :any,                 arm64_big_sur:  "28eb0093a129b7b8684db54399ccf65f57caa15534d29c91a5ee5912afcb5749"
    sha256 cellar: :any,                 ventura:        "f264149e96b1915be258811fdf981d1a4ef791a1eb4dc70054f280e40f786a22"
    sha256 cellar: :any,                 monterey:       "4a1d6468ae69ad46ac361d401b97fd435eb152674ee17d28c1af7c182d0c4091"
    sha256 cellar: :any,                 big_sur:        "506f4ffdf7491d11af9ac6b9cb55a7e189298040a74b10e83a5159e7ca5839a7"
    sha256 cellar: :any,                 catalina:       "3fee4844226ffcd22178834583d01a4d9de309d1dccd19f15639e7391c384c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61f50f7e65f056db4354f9c22b9d665617fa57d69e0b511b309120a86b205d0a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.10" => :build

  uses_from_macos "libxml2"

  def install
    ENV.cxx11
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-5.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
