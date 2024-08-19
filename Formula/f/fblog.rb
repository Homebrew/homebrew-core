class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "d4a25cdc27cd540b352b0515343f0100b0585712b7c4e5d9c8cd4afa1cbb9f91"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2e6e7cdeed3a4a9bd776c6c2ac9619d9d2d93cbf40594fd7de1de8963eeb738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da055a5c2672b153e6acacbde1de4c835027561f07bf3dfa630aa2ed0aa28ce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d16995dbfd51cd78f202acf339c2a100a739edcf6fe26156923dda5a698ed411"
    sha256 cellar: :any_skip_relocation, sonoma:         "b67c16fe20fd3b4a7c32b68fc1eef85e1da51db51fcf8a3b15eecd2a109cedae"
    sha256 cellar: :any_skip_relocation, ventura:        "9d9f29b2de8cba1f601cd4a721574e3b5d6a97a8f137f04961d98bb8d21a221b"
    sha256 cellar: :any_skip_relocation, monterey:       "c3ec19ff5d4e597c63780646673bdf6251dd49618529094a25a947a32fa5d201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc4ec5c0c091d58ba3464efac904c363c729316134b16e68f0134d869290dcd"
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
