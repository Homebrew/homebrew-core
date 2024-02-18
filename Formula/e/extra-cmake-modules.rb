class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  stable do
    url "https://download.kde.org/stable/frameworks/5.115/extra-cmake-modules-5.115.0.tar.xz"
    sha256 "ee3e35f6a257526b8995a086dd190528a8ef4b3854b1e457b8122701b0ce45ee"
    depends_on "qt@5" => :build
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89767a30feaac36cfb98801aa0b2650c955087b753f3770430be6b8378bf0088"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89767a30feaac36cfb98801aa0b2650c955087b753f3770430be6b8378bf0088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26f18ced38eb03f3177b77c3d7a9a127ea2319b16b3c0f45dcd855cdbc1b2d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d5d57dfd625083e0fed42a20f942587cbb9e88f1be935d19cded8d7ce7e3175"
    sha256 cellar: :any_skip_relocation, ventura:        "7d5d57dfd625083e0fed42a20f942587cbb9e88f1be935d19cded8d7ce7e3175"
    sha256 cellar: :any_skip_relocation, monterey:       "401012c2caad1080fafe510abbb22d0c1811fb964cc6996f7c196b41be415b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1300cddb75da1ccdbffcc556096cf55214a76dd1c40cf6df2bf6fad0553bf8e2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    EOS
    system "cmake", "."

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"CMakeCache.txt").read
  end
end
