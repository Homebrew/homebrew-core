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
  compatibility_version 1
  head "https://github.com/lensfun/lensfun.git", branch: "master"

  # Versions with a 90+ patch are unstable and this regex should only match the
  # stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*)?)$/i)
  end

  bottle do
    rebuild 6
    sha256 arm64_golden_gate: "0eaadc8c9a75308798d97b360663065c3b3d639a69f814459f6b95794d56a77e"
    sha256 arm64_tahoe:       "e973bb3a6d390dd73ad7b80aab57c8addb8dac68adfcefe4a37f91879ad8f56c"
    sha256 arm64_sequoia:     "994558434781a12b6bcb8a0c93aa4e92401ac2e189b00485b753f9c924acd463"
    sha256 arm64_linux:       "e70c6ac65c2a23d3d28e4b84ed0f0b316a853c777e09c13d0d7c26f65a58cb6a"
    sha256 x86_64_linux:      "db72b77fe5653b5c41df162c573e49057ef38a5dae6d1a6c4721e1b0ce0a3e39"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.15"

  on_macos do
    depends_on "gettext"
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
