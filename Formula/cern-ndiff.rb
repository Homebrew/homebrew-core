class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.07.00.tar.gz"
  sha256 "77c0ec591dc3ea76cf57c60a5d7c73b6c0d66cca1fa7c4eb25a9071e8fc67e60"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41ade2330d98fa812fe2e1e89751a8054ab9e9cc4cd9d173f5d9aee55796f3f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cf0cf2abed2d829e8e4f03ef88cbb3f225e42334091bb41bbbce269f7828eb7"
    sha256 cellar: :any_skip_relocation, catalina:      "2c91f51a18d6d7aaa821c6f7e43d624289ef2d12144a35f9eeb995fbf7263d0a"
    sha256 cellar: :any_skip_relocation, mojave:        "3398977b827a2f82dac08a2ec7d7b5289e61189bc7747ff2ab77a8f9ef9e23e1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "87aae51415565cadb2dffdae5dff93b472039b4f1ad90462b282e6fb7c855e76"
  end

  depends_on "cmake" => :build

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
