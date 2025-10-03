class Guichan < Formula
  desc "Small, efficient C++ GUI library designed for games"
  homepage "https://github.com/darkbitsorg/guichan"
  url "https://github.com/darkbitsorg/guichan/releases/download/v0.8.3/guichan-0.8.3.tar.gz"
  sha256 "2f3b265d1b243e30af9d87e918c71da6c67947978dcaa82a93cb838dbf93529b"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2468a859fd2e4f902e76f3ace98dfc55a117ec1a4ed6fe3a114c63020d5743e5"
    sha256 cellar: :any,                 arm64_sequoia: "a0d1e15669f361e19d404bdbb8b311443da4c4a775fdcb1d8d17a4fe03034e5f"
    sha256 cellar: :any,                 arm64_sonoma:  "b9f1f1aba6da5d653df4d082c3048724e14d221ef5fa9f3c1368413b5e703fcf"
    sha256 cellar: :any,                 arm64_ventura: "6b923b087914799d905e9fc2676231bc115dc5dca4dbc446e72fc7cabb943f21"
    sha256 cellar: :any,                 sonoma:        "642fc80010772295bbc9c393340137b0afaf4f51f3df6079a46103701ddde137"
    sha256 cellar: :any,                 ventura:       "8d8a76daa74d299ef906b105b25c98b62b5fbb3f6a7efa37ba7af5bba316f916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7a38413bdaf4f6c00720814ae66ca072ee9b860d174bd3b5d144fe01e90a039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d93c438a1966464eb85c1bc4f9d9743e9015502a06d90105e2f5b438c2df56"
  end

  depends_on "pkgconf" => :test

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"helloworld.cpp").write <<~EOS
      #include <guichan.hpp>

      int main(int argc, char **argv)
      {
          gcn::Gui gui;
          gcn::Container container;
          gui.setTop(&container);

          gui.logic();

          return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs guichan-0.8").chomp.split
    system ENV.cxx, "helloworld.cpp", *pkg_config_flags, "-o", "helloworld"
    system "./helloworld"
  end
end
