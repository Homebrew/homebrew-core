class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "6d27d6e9dfbe38270560751f932cd72659b73d4891117042aa21eba800f2ad9e"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e02a7a9d1545f4e9d227c5fbb1046f72611e43bc4480270f573cb87c0a625cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5cf4e716332ded13596d787d5c23f73897c7a77fbe086b480e1e1307f6d702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "198fa27793541fb09603c68c74b516c3c702495c1b4ae935a17d8e3b1ed521e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80cddf2f024cb60e2b5c3896671befa452d74541c330c80c2b5c5d35fbdf7a5"
    sha256 cellar: :any_skip_relocation, ventura:       "8c6b2986ce0c4bd11e40722188c53f746f4309b5d6348823dcece4f8dc8ac396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4414e8f4e92b3d7c8f745957f3d193f2120bf2c68146afd55b2a67dc6da28aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc321af614e20ee574d398ddad12d4b50a5b75761464162aac094986ca7c4287"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
