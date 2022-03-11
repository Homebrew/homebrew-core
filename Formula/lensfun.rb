class Lensfun < Formula
  include Language::Python::Shebang

  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://github.com/lensfun/lensfun/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "57ba5a0377f24948972339e18be946af12eda22b7c707eb0ddd26586370f6765"
  license all_of: [
    "LGPL-3.0-only",
    "GPL-3.0-only",
    "CC-BY-3.0",
    :public_domain,
  ]
  version_scheme 1
  head "https://github.com/lensfun/lensfun.git", branch: "master"

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

  def install
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"
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
