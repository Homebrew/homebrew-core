class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.08.01.tar.gz"
  sha256 "89c943fcb474344a4f7d28de98e8eae0aec40f779bf908daff79043bf3520555"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4021d6710141f31de9224732b1d3196d1dd315c86a13fcbc8213564a5390b743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef87f0ce60ad2f81011942a949a3e70b32ee45322c435cd860e406ad61e7f52c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c850063e8050b34b933757634a4b1119608e1afaee4f01e159c5c07f15da399"
    sha256 cellar: :any_skip_relocation, ventura:        "018149df6762d7886e66649ef2f75d422a460635f98550dafc26a99c9092034a"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b90768ba05a796a504a47ed93c62c617a2340f5cfc5716c74b9282225d56a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d17efd81d490ed73468eaf41dc2e64061fd01ba049c7ea1a22647b3c981cd0c2"
    sha256 cellar: :any_skip_relocation, catalina:       "06c3c33a9d470f3466dec139945861748aadf3c78a697d458004f14a503614d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a63d894f310616820d5e31d87c9e6d131694976e3b26a4f4cc7061d288bb50d"
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
