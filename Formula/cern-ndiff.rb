class CernNdiff < Formula
  desc "Numerical diff tool"
  # Note: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.06.00.tar.gz"
  sha256 "b4853e231b510b6153968190aedfe95a2b0de058324a2b9bcc70b795d73c304d"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb7ec4fd2605658c5d2ff764a6dc867c1322c673d6aad93acf9e269237a34907" => :catalina
    sha256 "77bdb65653b6d4ab9fd1b2f7b5f4af951fce1f50cd5403b3d30eeafdfd85c20a" => :mojave
    sha256 "66b88d2c6cf4f38ad0a3277175c83d99597ffdde3165905c9bcec285a6befd4d" => :high_sierra
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
