class Lensfun < Formula
  include Language::Python::Shebang

  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"
  revision 3

  livecheck do
    url :stable
  end

  bottle do
    sha256 "10c8d68811e3d286d340b8cdea0fff28380d719402f25e85ddc280e9d0a4b1fd" => :big_sur
    sha256 "d88e64dba59fb70ca04c45029ba2908d9d731dd94b835cbf88f488dd66c8c96c" => :arm64_big_sur
    sha256 "1e83aa5f7ebcb3d3952a384244adfacbf82b2954637cd3df02337f52de1d7b67" => :catalina
    sha256 "d0d64a98f863a5001667095eba97f55500a87610e00955c0edb95f70300e21c1" => :mojave
    sha256 "0050ca39268f8201a1c28169da62380385ba5e77954142404465e6b3cba909d7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.9"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    rewrite_shebang detected_python_shebang,
      bin/"lensfun-add-adapter", bin/"lensfun-convert-lcp", bin/"lensfun-update-data"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
