class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/5.0/libxml++-5.0.1.tar.xz"
  sha256 "15c38307a964fa6199f4da6683a599eb7e63cc89198545b36349b87cf9aa0098"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a98d69a34eb6d53430564fec383c63ec75b3e2b38fe8b2267f0d74b436d19136"
    sha256 cellar: :any, arm64_big_sur:  "a29a9c7c8a7982e2b2e568c9cf5fa5fd5be259473d3b8cae2690482e05652650"
    sha256 cellar: :any, monterey:       "9c875817f6ead741cc583af95ce3084a2b8fe375ae5f51eca94896d9bac5712e"
    sha256 cellar: :any, big_sur:        "69758d9c1040b13e69b2c93b9acff4de625114289369ad31ab32343a60e724cb"
    sha256 cellar: :any, catalina:       "c27918653b7a652ed111f61359da43fd054b68b0399cd2259a8f099c741ae149"
    sha256 cellar: :any, mojave:         "92dbdf72a137616d5a04fc4d6f92911db4463146ebc0fd4ff88350d11e9ca4fa"
    sha256               x86_64_linux:   "6c0512d0b89e78c7b934cebe4250e51a4b59199a5ad1a409beece4ef9084df02"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build

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
