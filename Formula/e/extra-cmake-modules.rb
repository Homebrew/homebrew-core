class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.5/extra-cmake-modules-6.5.0.tar.xz"
  sha256 "8f3c2ca1e502990629f3b68507189fc0f912f3cab279b500dac91ee7031a49cf"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e378a20795138aadfc17c0c111a22689c7ab419424f5d81bed01bcd3eddf063"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e378a20795138aadfc17c0c111a22689c7ab419424f5d81bed01bcd3eddf063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e378a20795138aadfc17c0c111a22689c7ab419424f5d81bed01bcd3eddf063"
    sha256 cellar: :any_skip_relocation, sonoma:         "23d1bebed92676329fcf9d64230b9ac8a6f98778ff2f4fc5dc08f48e84087fd1"
    sha256 cellar: :any_skip_relocation, ventura:        "23d1bebed92676329fcf9d64230b9ac8a6f98778ff2f4fc5dc08f48e84087fd1"
    sha256 cellar: :any_skip_relocation, monterey:       "23d1bebed92676329fcf9d64230b9ac8a6f98778ff2f4fc5dc08f48e84087fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e378a20795138aadfc17c0c111a22689c7ab419424f5d81bed01bcd3eddf063"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
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
