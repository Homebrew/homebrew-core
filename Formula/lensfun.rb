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

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "b7c1472fdec4cfa0c78c7be1d84cf62f1c1b5b9f243ea19d47a7d65d591029ee"
    sha256 arm64_big_sur:  "b4f90befa38fc5f0a2d7b981c63712cd53b98704f989f7d373ac072e38effab5"
    sha256 monterey:       "5dca57fa7d6429e104ab925f41e16f08d66adf767def8c523034c797721b50ce"
    sha256 big_sur:        "2c8cf34ada4b76d9d5a48cd05f0fb81dbdfc161fc0613dde4f393171021d3a22"
    sha256 catalina:       "f4e3e086ea86dc1475152084544beddfb8f6f2ec53b43c96b1be58b4cfdd65e0"
    sha256 x86_64_linux:   "58a7d7e275aa8eea9088f385d3801c4b0264fed650831f619823cd80d3b78173"
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
