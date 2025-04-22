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
    rebuild 3
    sha256 arm64_sequoia: "b11389793a1b5d34f1420828bc81943759514f949ae510f2517381a0835eade2"
    sha256 arm64_sonoma:  "abe73b9700f9b79b47be86862fa30ab8f9bd28050a84495cea82654191dd878b"
    sha256 arm64_ventura: "134398b4f3462fb1a3c1ba2c182ed7d1e67fba33822d41a17b0563433967d57c"
    sha256 sonoma:        "25ea14bd0c3af9e42ee0ead1a985340953baabd0ba7c717bab21fe5b41600351"
    sha256 ventura:       "fc6ec16c5ac0490fc08b5a7e4d3dee5d9c26b0a77129a957f6cd8b103673fb77"
    sha256 arm64_linux:   "516322774ac5d8ad2aab3c5a95c60b0409bac8c24c4fb66bd55cf602eb335560"
    sha256 x86_64_linux:  "acc1c2555c69186e8137edf8435a7341f2b2f3b237c2c8e561deef5cd3f83421"
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
