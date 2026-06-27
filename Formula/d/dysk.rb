class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "a712ce25f8c5867a29b699e5e22fed58b8884fb7ca112f01845c7a99b111dce5"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dea69c916d329b8aeae6e1b26c4536fb7c6bef17fd0e9ed466dd8262029a6f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be84ac8a18a71fb296888e015919b4a70ddf4784b5b2f0be3cd5a68fedc89c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bd2216643ad29247b3edd7019b1e1e1b5acf30468eab7a571887e809b1f8ea3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30d40a4f64097ea97d2616541fbe1fcc52e4e657152f56f975a5be0ef8e2166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e46b3bf8f82e687cf6a3e6b54069236f0648742d36930f606042e5d5c56988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4df4f695dff0b3a457b8553ed3969ec8943d346b170bf36399ab40f2c615639"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
