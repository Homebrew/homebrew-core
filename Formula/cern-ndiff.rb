class CernNdiff < Formula
  desc "Numerical diff tool"
  # Note: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.05.01.tar.gz"
  sha256 "0634b14bd00234ef44d37e47a884d4031fd1a2062475553198e83923a7c918e5"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51ade6e0cb3717a6123da78cef16a2e77cfc7544f613ee24df0b5122d8c27963" => :mojave
    sha256 "4dd0bd56b604a2d94d569498749baab86242c8fe4eb20c12364f510a8643435f" => :high_sierra
    sha256 "dbc2378692211fed755ffef20423329fb5f20ebbd02411adf1a77f23df9333fb" => :sierra
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
