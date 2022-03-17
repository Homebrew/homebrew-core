class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.92/extra-cmake-modules-5.92.0.tar.xz"
  sha256 "f89a238bc5f28738db25e29296b75b4f795e3e9bfe3a8f1f9390648749d303ef"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abe243d0a9f54d6f80c1cac4d02b1c912df09921df6cc3d324fa9689a999ae88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09df0f178df062e3db1d9b40c224a09fdcf7fcfa202b789cf392cd0172841ce3"
    sha256 cellar: :any_skip_relocation, monterey:       "273b1d3b008c8ccaac09f4095edb8dd0f1c5a29cf2ca004043d9af6fa6e10cd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee4dc9bcfc563322bdfe0c2a27ff39bacbd36d966dd607b6c8594652affb158c"
    sha256 cellar: :any_skip_relocation, catalina:       "273b1d3b008c8ccaac09f4095edb8dd0f1c5a29cf2ca004043d9af6fa6e10cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b6a73ea3b29dc8548412fda751f2a2ff576bab7b592632874215535a8394bcb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"

    expected="ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, File.read(testpath/"CMakeCache.txt")
  end
end
