class Fpm < Formula
  desc "Package manager and build system for Fortran"
  homepage "https://fpm.fortran-lang.org"
  url "https://github.com/fortran-lang/fpm/releases/download/v0.11.0/fpm-0.11.0.F90"
  sha256 "988a3317ee2448ee7207d0a29410f08a79c86bddac3314b2a175801a9cf58d27"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21e756e56a9c35cbb2c0849bf7767ae194283d6c466de61e3ec9c5b922f33373"
    sha256 cellar: :any,                 arm64_sonoma:  "2ed294de5db197bb728de646f43560bd0cac9702f848e97ce51b758697258b4c"
    sha256 cellar: :any,                 arm64_ventura: "41324372541beac98661f13ac43ebe6b04e022d77b911896a4a968acd25f31b6"
    sha256 cellar: :any,                 sonoma:        "4f07fdd691265418345caf32995c53ace46f85580433a3430b17415cd8a77bcf"
    sha256 cellar: :any,                 ventura:       "13c413c368aa578e3f01029eb0e6f32145ae27dbf3039521fa3a4a28ccf26e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c912b9ed0c04c99ab08fb272e8d8ff8b76e3bfd6256eb82e30e289982de1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "484e5f0966895beaa67c50b37422f287e35787da9a4aa3e2940b07a479c236c0"
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
