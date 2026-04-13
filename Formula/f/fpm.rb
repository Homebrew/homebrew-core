class Fpm < Formula
  desc "Package manager and build system for Fortran"
  homepage "https://fpm.fortran-lang.org"
  url "https://github.com/fortran-lang/fpm/releases/download/v0.13.0/fpm-0.13.0.F90"
  sha256 "001cff6cf1145f215baa0888ba27acc06cea30a89b79d1a8be97db3fffbc8cd2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0c8a9c7bd941113f3a9c1ef903ecbbaad3fbda64a5630b8154a25f5f26016cf"
    sha256 cellar: :any,                 arm64_sequoia: "16c3a8ce7fdc84f13ee8d72e1c8e08d722f371aaf08336d7c54fb820788df747"
    sha256 cellar: :any,                 arm64_sonoma:  "4bff3ba47d8da676902f6b274d84d9baa1b152ddd53adb40a3ad49d27a30be9a"
    sha256 cellar: :any,                 sonoma:        "366015d4ab1c22e54af50f331493f6080b6bba360ce1249c1afece58b5dc89ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "893905a199b85d91ec31f1f26c85d969aa65ae984d89aeb0c44662c7ae1205f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f029da9b65ee287ff32fda194c4fee087cfe3b1e4f09cc04b0aa7044c6fb14b4"
  end

  depends_on "gcc" # for gfortran

  def install
    mkdir_p "build/bootstrap"
    system "gfortran", "-J", "build/bootstrap", "-o", "build/bootstrap/fpm", "fpm-#{version}.F90"
    bin.install "build/bootstrap/fpm"
  end

  test do
    system bin/"fpm", "new", "hello"
    assert_path_exists testpath/"hello"
  end
end
