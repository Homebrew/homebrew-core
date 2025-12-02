class Bedtk < Formula
  desc "Simple toolset for BED files"
  homepage "https://github.com/lh3/bedtk"
  url "https://github.com/lh3/bedtk/archive/refs/tags/v1.2.tar.gz"
  sha256 "c0e1f454337dbd531659662ccce6c35831e7eec75ddf7b7751390b869e6ce9f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "495953151b05090bee059581e5a872112a6621265f86c8be00d6a43fdec0d25a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7353b0431b57bfc23ffcdf490681771bab0f608a1c590ae24ca0e8f437613809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a58dd66680c40dbd672a148a9640784c434f6d520bb88f6696c04cc31683a15"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebad975371a395fab0ef08706244c491def00e494e657b15463da7cbe288893f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d359cee1ad085e9a9fc2e36e63fde511e47fb12103526b843efccc8dfb19821f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dec9cdbe36442a536160a54b14e5d07eaa1a7f6e59dcd73d0cb154854211562"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "bedtk"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    system bin/"bedtk", "flt", "test-anno.bed.gz", "test-iso.bed.gz"
  end
end
