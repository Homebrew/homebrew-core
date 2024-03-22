class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment.
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/refs/tags/5.09.01.tar.gz"
  sha256 "22dfb4e2b6ef60dafa216c4bb60deca3d3a48e6c8e3f3a2bc01cf8fde8150d79"
  license :cannot_represent
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a06123cf4c5e24bc85d9e209c2988ade7186c7b8a67b3e255ecd7f8623a12f36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b836838727ad91eb05321b70112f6c853c517e8900a807d5a928049bd1d374c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aaa4d49c0385e2b0c9ddf559eba71021af22c0246e906f6413a878ad148610f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa16d9b4cfe490a1447d1f21375063451222269ba3483431d102af24beca2b7c"
    sha256 cellar: :any_skip_relocation, ventura:        "697412c7637d4ff2b1767b58d6b8ffa1d7efbefc87614af772e55529dbc877f8"
    sha256 cellar: :any_skip_relocation, monterey:       "46cd5ca222a6a7059634587a8bc13973e204c9c7453dd11a66bf117e09722805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cef3cffaf2c85bb16a020aa6ec65a048d9f1e644a88f4f40089f29b07316e26"
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
