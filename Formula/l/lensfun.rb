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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256 arm64_tahoe:   "c04d1179c9ddb6a6c56495d942509d502478de5654631709c5d1cba41fb1d1df"
    sha256 arm64_sequoia: "b9d366691c96aa2e9cc86df636e8fa62e4016712a97b865bf976c86f3c3a8be9"
    sha256 arm64_sonoma:  "e339238c789ba00a0742a0878b534d646d447e9581ad6556317fe52e33462b72"
    sha256 sonoma:        "3cc01d582abd35c7071dc57e600d076c9e7db789793dde489e751f383279140d"
    sha256 arm64_linux:   "8431034a807c782f9b8da3ce8b3c0d482e61ae4557d596cac35b31ddbf2f9c0d"
    sha256 x86_64_linux:  "85581789aef7eea988ee657559321b555bce95b962a6298156fd6d1ac2453cf1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.14"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.14"
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
