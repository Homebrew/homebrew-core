class Lensfun < Formula
  include Language::Python::Shebang

  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"
  license all_of: [
    "LGPL-3.0-only",
    "GPL-3.0-only",
    "CC-BY-3.0",
    :public_domain,
  ]
  revision 4

  bottle do
    sha256 arm64_monterey: "530ebafb7cb54daaa3095f543ba8f05e331fd8a36265fbb2cfbe482e5822a223"
    sha256 arm64_big_sur:  "976711172998eae467ddaba1feb590e0229cc0b41f11ac58e1db2d833a57c99c"
    sha256 monterey:       "08fec3eeb7b95d1c468b2525e2b92a7df9c34f1b6c7f4003d2c0cdaeb72f983f"
    sha256 big_sur:        "48cd331c4214979daa6c122e2b776000af76208cb051562e27f4cef4f3aa3b93"
    sha256 catalina:       "b0d8cdbcf20af0b1d577626e04643687955030785f57911e9d0a708a7ef95997"
    sha256 mojave:         "526b6752883c94e7e2807fa06e6803e9dc45060189be102be5ed79c24b187af6"
    sha256 x86_64_linux:   "d5758ba26c4bb2d4134bc733a302a30b6534f7b5e64dbd25ec519c39f5234c7a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.9"

  # This patch can be removed when new Lensfun release (v0.3.96) is available.
  patch do
    url "https://github.com/lensfun/lensfun/commit/de954c952929316ea2ad0f6f1e336d9d8164ace0.patch?full_index=1"
    sha256 "67f0d2f33160bb1ab2b4d1e0465ad5967dbd8f8e3ba1d231b5534ec641014e3b"
  end

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
