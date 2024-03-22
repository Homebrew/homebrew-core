class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.0/extra-cmake-modules-6.0.0.tar.xz"
  sha256 "23992bf19db717156b7d6dd13118caa79fd57f090beb062e8308db3c09f70d0c"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25365d192ade720851fe1fd5c597e0cba2b1ff2c01da2e672e623ef2051412e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25365d192ade720851fe1fd5c597e0cba2b1ff2c01da2e672e623ef2051412e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25365d192ade720851fe1fd5c597e0cba2b1ff2c01da2e672e623ef2051412e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2044e06efc724680757efafece7b2bb8e426c7ce38b65e6d1c910a87b9b6d64c"
    sha256 cellar: :any_skip_relocation, ventura:        "2044e06efc724680757efafece7b2bb8e426c7ce38b65e6d1c910a87b9b6d64c"
    sha256 cellar: :any_skip_relocation, monterey:       "2044e06efc724680757efafece7b2bb8e426c7ce38b65e6d1c910a87b9b6d64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25365d192ade720851fe1fd5c597e0cba2b1ff2c01da2e672e623ef2051412e1"
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
