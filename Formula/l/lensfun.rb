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
    rebuild 1
    sha256 arm64_sonoma:   "4509de164f26e03f7dde33e45c7c82994ade1cd087118ea44d096966e820aa21"
    sha256 arm64_ventura:  "4d66d4326ff847e40cbdea3efad6b141ca4a60e3af369dfd38b0bbac05377693"
    sha256 arm64_monterey: "d3b2be29200d9d2fed399acfa6c3688630f67a8d92d934fa201ccb926ba9d3ee"
    sha256 sonoma:         "893fc14bc16e6841f22f8211f980ead61bf157f1a2936289dda5de3a46684d67"
    sha256 ventura:        "81b1d46a4bbbf4dbfbf634713a997fa2bf7b060e65ad7b981a470ab266495f73"
    sha256 monterey:       "130ff44bb69bfeae078ddf16c2a4dcae0750e16db4e54e81738c56dfd8fc875f"
    sha256 x86_64_linux:   "2e4d736b2e405d14c4b18b5ccd316455927ef40b74076131d4b1bf37c5001b8e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.12"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Homebrew's python "prefix scheme" patch tries to install into
    # HOMEBREW_PREFIX/lib, which fails due to sandbox. As a workaround,
    # we disable the install step and manually run pip install later.
    inreplace "apps/CMakeLists.txt", /^\s*INSTALL\(CODE "execute_process\(.*SETUP_PY/, "#\\0"

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_LENSTOOL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children

    system "python3.12", "-m", "pip", "install", *std_pip_args, "./build/apps"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
