class Fpm < Formula
  desc "Package manager and build system for Fortran"
  homepage "https://fpm.fortran-lang.org"
  url "https://github.com/fortran-lang/fpm/releases/download/v0.12.0/fpm-0.12.0.F90"
  sha256 "61567ac810d8ea8f8fc91fdb13700d34b91bf36e193b35d744fc6352d21146ad"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e05d00505af1079dc24ff60fcbe77a93312c33a7ae0d61db151fa4fb1081ee61"
    sha256 cellar: :any,                 arm64_sequoia: "7e811adad308853f88abed68053914560cbfc4053c15d23d68c864d564ed75fd"
    sha256 cellar: :any,                 arm64_sonoma:  "10a390a5685e4dc39c4b56fa5913164e043404f4d773b5fc389e12e3f42a1c18"
    sha256 cellar: :any,                 arm64_ventura: "37d76ffc9a989a66216fbd2d31e33b66036676e23f3fd56a8a92ca2a772922fe"
    sha256 cellar: :any,                 sonoma:        "edac542d869278323ea107b0ab9ed7fc5f4e92da1ef2479dba5390a93badb7f8"
    sha256 cellar: :any,                 ventura:       "cedd5b807ca1407ee6fbd68fb825c86ec937ce28ee1f64165758adf101612f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d56186251ffa441b3caa188648a0e2f2980f308e308f32b2a4984b65c42874a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fac8ba76bad2cd97e0c8ee2254fbe007e8afe69b687ab673a4b0a675159f0507"
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
