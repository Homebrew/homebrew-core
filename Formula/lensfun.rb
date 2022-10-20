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
    sha256 arm64_monterey: "9486d22108299332ec92369f4e7338111a744f214c52ebb384db654ff7379699"
    sha256 arm64_big_sur:  "98cfcaef6655bb8a9a67b1a9feaca1eba526f3b8ce46e35f40449f43902844cc"
    sha256 monterey:       "1545b2a59105bb4906394498c6e21c2b4d1398d2a3301c6fc58c3106ccb37bae"
    sha256 big_sur:        "07e1c1cca921506244057b958860353249aa676fd36d7bfc66d20da2d3281851"
    sha256 catalina:       "1130d39462b5b1957109a78b93c31e3f1618860f37270c71e51213173193d2b8"
    sha256 x86_64_linux:   "35c9b93d5196c8cd249b00ab7a7ad8347cb72ad57326fd4753f8fce01aaa55f2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.10"

  def install
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    site_packages = prefix/Language::Python.site_packages("python3.10")
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
