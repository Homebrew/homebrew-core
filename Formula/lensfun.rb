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
    rebuild 1
    sha256 arm64_ventura:  "ef9f653d3d28f3b9f10eef3973094cde751b78a8815bcae285ba271b349f3ef1"
    sha256 arm64_monterey: "ed49275ba955ff9fee5394f999c649a4eb6d68be49c848ad204d07431a57e48d"
    sha256 arm64_big_sur:  "8737bff57e3e28d7b751707c157742489dec1d10d964b31c79482412da592319"
    sha256 ventura:        "71abae1ecebfe1ec29396443f1dae852aa04cacab8c60b4ddc8cc72ca50c23ce"
    sha256 monterey:       "2436c8ab001cad2d2a3bd48bb6ad714bf04ac0662060d1daa0d3f4916c1f743e"
    sha256 big_sur:        "b5c275b1cc161df5256c79b0b9e51d1be1d7d4d9fef5ebe050453471b16c6852"
    sha256 x86_64_linux:   "3f439e1ad1542f7ee9332679d956e6a64599e65105d21f25f88dfbd1fb9769a9"
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
