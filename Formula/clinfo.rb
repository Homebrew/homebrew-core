class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/3.0.23.01.25.tar.gz"
  sha256 "6dcdada6c115873db78c7ffc62b9fc1ee7a2d08854a3bccea396df312e7331e3"
  license "CC0-1.0"
  head "https://github.com/Oblomov/clinfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f813fa0658cb136354ea6fd6a304f4ed37937bde4b5701dcee354cde08b5e2e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762985fa4b310ff913ed54201ef1910070ecb0dbfb90b57fa7d04254d810ab00"
    sha256 cellar: :any_skip_relocation, ventura:        "7f21bc4670f3da38530454e12368b2790059d534d428e77a952f78271c4af928"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf37e1369f567bfbf671cfe8b9fa85cc58d29e24eae65a002ba1d8bb1124c4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "05c53fe5c0be798e7e7d7eace29593b88c15721d5d8db010c72174ca7464f928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9453f23f10fc0cf9c28fd0b64e744c19a437e0466411cb88addea9abdecd5f0"
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(/Device Type +[CG]PU/, shell_output(bin/"clinfo"))
  end
end
