class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v3.0.2.tar.gz"
  sha256 "8ca2a2c40b96834c21e7bcdfe90dd9cee1103410934a70209d8a617a748160f7"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9834bc4291e2ac5f1a50c23de5c3d7660aa1baf97eff20b5195b9490a5241af4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f83b37b77e72adbbf90fe6679ec929d199e70de6e73d94bf9bf0707e9c952344"
    sha256 cellar: :any_skip_relocation, monterey:       "dcd4ede103237181993b7f36506169c04205719340b484ff623af89a10aeb2cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed009c9b8a0ec2ea2c321f386542a409790605ba93fb186ee003361c98f29d40"
    sha256 cellar: :any_skip_relocation, catalina:       "d3118970c617f0b55a5512ea90cdc030809d7f9a1f4c8d06b13c5db013e344a6"
    sha256 cellar: :any_skip_relocation, mojave:         "419b3983e3ae3bc752d458f2f6aea11f13f4dc1ac48cb334a4d8771c8ceec134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa6e512521710cb26f1cc8f8caa362598110ac1e8fcb94fab560452a211eaa7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
