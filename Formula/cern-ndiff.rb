class CernNdiff < Formula
  desc "Numerical diff tool"
  # Note: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.06.00.tar.gz"
  sha256 "b4853e231b510b6153968190aedfe95a2b0de058324a2b9bcc70b795d73c304d"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git"

  livecheck do
    url :head
    regex(/^(?:mad-?X.)?v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "df835dc6cedc8d04c6113667fbc6344d5a16c900524b9c8b99011d83c43c50ce" => :catalina
    sha256 "48f81ce73037ca0c8043fe8a3c327448f174c4375958d68fbbcf8ae923e9556c" => :mojave
    sha256 "07eece89be8b6eef97d06aba5fd326b4d06e9fb251e503ea5c61590e2a0e4dc7" => :high_sierra
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
