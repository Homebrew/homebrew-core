class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment.
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/refs/tags/5.09.03.tar.gz"
  sha256 "cd57f9451e3541a820814ad9ef72b6e01d09c6f3be56802fa2e95b1742db7797"
  license :cannot_represent
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0928e2310a409c4752049d1d77878106f8fb8e869b10e2d0d293b7041d4b0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33daa99d5dc73c7e7b756af88e4fd25bb4946cb93b2c77c72bfa821acfc01f61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "206ec5e472281032c15bd13ea5632b8863a69a105b07eb557db0c7fb2f64fdd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "573fd566f238b8bc3757cc774245b07813bb3d732b84d79de4e11df0fae517aa"
    sha256 cellar: :any_skip_relocation, ventura:        "1bf5c58e0f613f541c2a9fa99952ca3a96953bcd28da1baad4dc231e63ec5eae"
    sha256 cellar: :any_skip_relocation, monterey:       "3a0729dae6b6be96a7f50e03924b5948a30d78c6768c69952e25e06091180352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1c4a59699c171dd10f9f7cd73796c8d23714e517330da7a602dd06fdd04af3"
  end

  depends_on "cmake" => :build

  conflicts_with "ndiff", "nmap", because: "both install `ndiff` binaries"

  def install
    system "cmake", "-S", "tools/numdiff", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")
    system "#{bin}/ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
