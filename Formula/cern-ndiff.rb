class CernNdiff < Formula
  desc "Numerical diff tool"
  # Note: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.04.01.tar.gz"
  sha256 "94e14060d4b5c6bebaa7446f0134d6eccb20423d4a27df39082004dd29288310"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e810aa4514ce9bb4c0372ca03a759ded3f49fab15fdadff8fe9c51982841b9d8" => :mojave
    sha256 "4d41effe39127598b9eed196eb2802c81b3f48decb139183fe69670e9f98e8b3" => :high_sierra
    sha256 "9a1d68667b2ac122f5245e5b9af2154d5ccb18d82b2d34500b8fbcb089ef90a0" => :sierra
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
