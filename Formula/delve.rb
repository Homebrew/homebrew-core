class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.9.1.tar.gz"
  sha256 "d8d119e74ae47799baa60c08faf2c2872fefce9264b36475ddac8e3a7efc6727"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8677b21ea08fad3ec382c08feaad3c6624c0fea4a02b3fe776a9b507f2a6ef45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ceffaae98f8e76c57657d101d3f68fbf1c4388a4ef9ffa771b40860f10645cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b59faf3121f887d24d3990b72ff9ad6dd068f37108a2f85d2b907c788b1b9e14"
    sha256 cellar: :any_skip_relocation, ventura:        "d5d1692d06b953ca015a2b5c733a2a2aac8b5bd66eaff1a4b847d0ed580cbead"
    sha256 cellar: :any_skip_relocation, monterey:       "602d51e02775aa33db10a763881e9e2264d620f2a0e4d85bfb1b2b5309abbc10"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea395ed8a2f54f80345f7919215e9d91cf8d1d55a03461f26700b284626b9dc"
    sha256 cellar: :any_skip_relocation, catalina:       "fbcb931a825234eb1f070184043a072f064a5c6c7c9540e5cd4a34da14becc7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876ea706f995773c05c1d269ea4d6b565b6208291e1697b44cc0ec754fca1175"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
