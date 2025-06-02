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
    rebuild 4
    sha256 arm64_sequoia: "19e6455ae24f5deb3f96089c18cf11b77f4fc3d03ca77761e2985d33aeea3e63"
    sha256 arm64_sonoma:  "06508767287b05cd51b631ea7b6c4d01b3176ba7cbe14412b79df9f3c47dd252"
    sha256 arm64_ventura: "e54fe0c3f77d0a79a0d9b6850807db5ce3ce136790d4947bda4420e2c4f0596a"
    sha256 sonoma:        "33b45fe0015b3aa498efbd6d83557352f1646750e6fa137e611d10c56329c14f"
    sha256 ventura:       "79f780f2be84affa0ec87493db70a520cfd2e675c7c3ecc4f001c16f66bef454"
    sha256 arm64_linux:   "59a7a77209ba18eb6b81d5965159eb16ff10b83ed6ac49e2afce1118a4b1f2ab"
    sha256 x86_64_linux:  "c668142f49f3abd0b1dcbfd48d6dbe43ea7faaf69ff2462cb5bbfafba1f060c4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    # Workaround to build with CMake 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    # Homebrew's python "prefix scheme" patch tries to install into
    # HOMEBREW_PREFIX/lib, which fails due to sandbox. As a workaround,
    # we disable the install step and manually run pip install later.
    inreplace "apps/CMakeLists.txt" do |s|
      s.gsub!("${PYTHON} ${SETUP_PY} build", "mkdir build")
      s.gsub!(/^\s*INSTALL\(CODE "execute_process\(.*SETUP_PY/, "#\\0")
    end

    args = %W[
      -DBUILD_LENSTOOL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
