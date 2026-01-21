class FortranStdlib < Formula
  desc "Fortran Standard Library"
  homepage "https://stdlib.fortran-lang.org"
  url "https://github.com/fortran-lang/stdlib/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "07615b1fd0d9c78f04ec5a26234d091cb7e359933ba2caee311dcd6f58d87af0"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "633a47fa6b26208e6192b4b0793586ffcc7d706228e0b168d308f5820a930b68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349996236701c1fdb6a5fdec58dc627f3550929fb8ec80509b8f8d380fbf19de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f37094c09728b25724680dcfee1aa5e2fa9da72e55787fe601156af2c397601f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1453730b11fe70788ebce7b4a007a9536d4f323bbf4b41f87d8136d6f4ac820"
    sha256 cellar: :any_skip_relocation, sonoma:        "88b04ee788cef96770fb93382cdeb2cf18c7892f2b939ae39f058b1da46a1962"
    sha256 cellar: :any_skip_relocation, ventura:       "0a92743f68b516233fd5796fd48b6070a75ecaf9d1176b7705cadee4ee3df04c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b972e6d0193d93e1278d9c73c90a3013c1a9be32d3afe6e626fceaa2febfabe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75455c2f164e2797e3e05ec2fe8b0528cb16c1fefbb5a84a3a29be96b17b427d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "fypp" => :build
  depends_on "gcc" # for gfortran

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/version/example_version.f90", testpath

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES Fortran)

      find_package(fortran_stdlib REQUIRED)

      add_executable(test example_version.f90)
      target_link_libraries(test PRIVATE fortran_stdlib::fortran_stdlib)
    CMAKE

    system "cmake", "-S", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
