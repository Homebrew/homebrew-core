class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/refs/tags/3.0.25.02.14.tar.gz"
  sha256 "48b77dc33315e6f760791a2984f98ea4bff28504ff37d460d8291585f49fcd3a"
  license "CC0-1.0"
  head "https://github.com/Oblomov/clinfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f9f30aecde66c0eb0938f035b92db105242a3fe45ece3bc6c9c7d4b97f663d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66be00f1c03820544063ebb39af878d24e1571a45e7c9bbc4cd6c1f2c576a927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e0a75e7745ea32b3db3afb79fadd612b0e432e8412ed3f8e90768b46502b415"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f291734139a5f97270e79760822919be0824e9f273c732f796590c343e18e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "b844184911efd1eea8fc994b07e2e02c1ffbbc63c3fcb771ebd1ea588d02e337"
    sha256 cellar: :any_skip_relocation, ventura:       "e13ffb6563cda2a028befe3a148ddb8bbe6c38f6fbf3cf4d9a82fd2a3ba7a8c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbdeca056b99bf6960da8a6ab7c8533da3aba2efbf6afea09d5fa7be08bbba5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e95ee551467da22ea1a32580ad4e42ff3ea26a1cdb66e3a63dd9b53e01f5f1"
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
    # OpenCL does not work on virtualized arm64 macOS.
    if Hardware::CPU.virtualized? && Hardware::CPU.arm? && OS.mac?
      assert_match "number of devices : error -30", shell_output("#{bin}/clinfo 2>&1", 1)
    else
      assert_match(/Device Type +[CG]PU/, shell_output(bin/"clinfo"))
    end
  end
end
