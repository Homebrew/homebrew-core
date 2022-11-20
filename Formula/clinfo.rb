class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/3.0.21.02.21.tar.gz"
  sha256 "e52f5c374a10364999d57a1be30219b47fb0b4f090e418f2ca19a0c037c1e694"
  license "CC0-1.0"
  head "https://github.com/Oblomov/clinfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a32c61641d925f1c4273db20ce0a9e0891dbe388a93db1c4ae398f68b13198f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d0c2af62d60954d4046e4c8f7dd16e16d90957462b7f1e98277e3fb88ba018"
    sha256 cellar: :any_skip_relocation, ventura:        "22dd33865487662965aeb057ae5f443ce40359b4555c5cc836d70b40de855d6d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5e0204e873a5efe9e06a03dca323dd1875a148a99bc771d1a777ddcc5a0b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb20a0053dd57a483815485e804884ba93cafde11b2d265285a7ad0b49fd3705"
    sha256 cellar: :any_skip_relocation, catalina:       "fe9953456ce92ca4701c040d4971be611671ab058c4743802c4721a5313e2bf1"
    sha256 cellar: :any_skip_relocation, mojave:         "6165806150adf656308b999a1fac88effdf0fe5128b39d21c4faa0cda9b3c491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99db424979264c6c3e4f8e3b1eeb9a9911fac5129558ba5c801eb302b0f9c91d"
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "ocl-icd"
    depends_on "pocl"
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(/Device Type +[CG]PU/, shell_output(bin/"clinfo"))
  end
end
