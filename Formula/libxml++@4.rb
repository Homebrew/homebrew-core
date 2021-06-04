class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/4.0/libxml++-4.0.1.tar.xz"
  sha256 "8665842f5dfc348051638ead33e4ea59ca79b0bf37fa4021f5afad109fccb4da"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8f7ced4c24bc53e26eb8324269e5fddcd7eaeb069a137b8b7c1e609841c8527a"
    sha256 cellar: :any, big_sur:       "c1c5969140b08c3360dcfa048373c5414d7898963ce1e2e86087dfe9ee3ad78d"
    sha256 cellar: :any, catalina:      "7c7babf431b2224efb566afc5053c26c9df31609cc136bdb901ca419c8e6e11e"
    sha256 cellar: :any, mojave:        "e0fc524dd6afd8094de610a76bfed2b2e96147c5aa05b8d24150721ec2eafd6e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glibmm"

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
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-4.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
