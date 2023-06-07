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
  revision 1
  version_scheme 1
  head "https://github.com/lensfun/lensfun.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "1e47a3ce9b679747161cbf607127367249001b2162145787fd1f501dc4f0c477"
    sha256 arm64_monterey: "5cd6ce6eec9f17b7bd176e3980b0047b9c497a4899d0e1a449185a2f026391ee"
    sha256 arm64_big_sur:  "dbb34f96dc6fca84aed8450d617729cc6194e34069947c1e4c43adc27156c02d"
    sha256 ventura:        "cdb64408d7544e20f2ac9cd204d7c3e18740589e25a763aadcb1e51db476642d"
    sha256 monterey:       "f0194e2764c774b9a86e3016e41922a8c5a03e9c1513035b01dcc6019d99c1ce"
    sha256 big_sur:        "b28108432c9ce8dc6f0947513082830fdb9673257701576892b544c46054c78d"
    sha256 x86_64_linux:   "36cd0c58b8026f0712a6bbc25bfb287033912d80ba42fcfaca700f80282c9a04"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.11"

  def install
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    site_packages = prefix/Language::Python.site_packages("python3.11")
    inreplace "apps/CMakeLists.txt", "${SETUP_PY} install ", "\\0 --install-lib=#{site_packages} "

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rewrite_shebang detected_python_shebang,
      bin/"lensfun-add-adapter", bin/"lensfun-convert-lcp", bin/"lensfun-update-data"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
