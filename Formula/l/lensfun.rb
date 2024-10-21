class Lensfun < Formula
  include Language::Python::Shebang

  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://github.com/lensfun/lensfun/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "dafb39c08ef24a0e2abd00d05d7341b1bf1f0c38bfcd5a4c69cf5f0ecb6db112"
  license all_of: [
    "LGPL-3.0-only",
    "GPL-3.0-only",
    "CC-BY-3.0",
    :public_domain,
  ]
  version_scheme 1
  head "https://github.com/lensfun/lensfun.git", branch: "master"

  # Versions with a 90+ patch are unstable and this regex should only match the
  # stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*)?)$/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "bd7e0e0ee91095a654b790be77beaaf678460b7ca5a93761acc7097cbe49c8a4"
    sha256 arm64_sonoma:  "1b94bfd9c7bd10c9b2a750d636f26d00e631926a82177bc17a602eee34cd5b59"
    sha256 arm64_ventura: "ddda4af3259759e007b235ef56e81ec47b46210953f267880ed3afe96bbaba71"
    sha256 sonoma:        "2281557eb46d5d02057d55a99e8709f331ccb48eb953673cc579ab0ecc8256d7"
    sha256 ventura:       "2682f7ff29e3752b24cbf18b04470fe2f12b2d23c7923ff456fa9f65692728d9"
    sha256 x86_64_linux:  "3d243858a098eb0412f6f92c1e0c536e21621bc4982b24a9aca530736e64fd0d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.13"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.13"
  end

  def install
    # Homebrew's python "prefix scheme" patch tries to install into
    # HOMEBREW_PREFIX/lib, which fails due to sandbox. As a workaround,
    # we disable the install step and manually run pip install later.
    inreplace "apps/CMakeLists.txt", "${PYTHON} ${SETUP_PY} build", "mkdir build"
    inreplace "apps/CMakeLists.txt", /^\s*INSTALL\(CODE "execute_process\(.*SETUP_PY/, "#\\0"

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_LENSTOOL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./build/apps"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
