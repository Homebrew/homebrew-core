class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "a5021d85a70184f098ebd7e704f8b2330404f4c760de09af6da61b9ce182a49a"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca8c5a7aa8563240046520a35331290a6d64192d7ae3bdbaffe733747fad636f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "809af34ae9e73f2ecc6651c80315c588f8c67592a24872e8db1ae78003d58795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "809af34ae9e73f2ecc6651c80315c588f8c67592a24872e8db1ae78003d58795"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "809af34ae9e73f2ecc6651c80315c588f8c67592a24872e8db1ae78003d58795"
    sha256 cellar: :any_skip_relocation, sonoma:         "60bb4040f2617024b74bbdc0d388d22d9ca71998a91488eb9b3e506a30127cec"
    sha256 cellar: :any_skip_relocation, ventura:        "f2068378022c9da1035ed77f3da67a43e86d3e91d39dea9a2ab92c12dc9b4878"
    sha256 cellar: :any_skip_relocation, monterey:       "f2068378022c9da1035ed77f3da67a43e86d3e91d39dea9a2ab92c12dc9b4878"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2068378022c9da1035ed77f3da67a43e86d3e91d39dea9a2ab92c12dc9b4878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaae85c66a4c2e343d14bd9b606c232b55bc4fbbb39c87e6c2490d969c8b10f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
