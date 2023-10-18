class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment.
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.09.00.tar.gz"
  sha256 "fc2823cdb90a53c1422cca93a48b003c97c1e72641d9e925cd8f59b08f795c7a"
  license :cannot_represent
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3a9acb0c57bf685ba16ddf97ababae58451ac0af5375e59f732ceec5ce1f1b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92113f5cfdd408e3e6d144aa5290709a691cae486aacdc513af10be0160d484d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e1a138bfa3f3c1dc254beafe791f8b0748a0cef867bf127fa980731299075a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ce91e3f3bb0bdcab6babe3bba385d18d65d6cf6f24de23c71fd39cd8157a7f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "996f97ac44e2c81f07605231eaf76035157168daba48a275e761f6d9840ef7be"
    sha256 cellar: :any_skip_relocation, ventura:        "26c731438e58d46fcfb04b356e6d3cb9a83de2e5588a027827b04611a3df514c"
    sha256 cellar: :any_skip_relocation, monterey:       "718fb107f6b55a696da01252ce562855c164f53046d0734fc7f7b81c2fed377d"
    sha256 cellar: :any_skip_relocation, big_sur:        "456dda19013d2ffa8d889ccf5fa29920e9b2168d15d315e1160ee207c798bcd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45481fce67f3760a63d6659bb562b78766511881b8b16c9ba46436e5ce6b638d"
  end

  depends_on "cmake" => :build

  conflicts_with "ndiff", "nmap", because: "both install `ndiff` binaries"

  def install
    cd "tools/numdiff" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")
    system "#{bin}/ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
