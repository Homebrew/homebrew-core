class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e827a2de78b90b9c91eafc5973e4eb20b87ef9d294892b78c73926951cd5af1f"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e58c4157712d0b296b034e0289318e99b31691ecbab5e46f052de1d18f863f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a61ddafea4e0c23b576c69af0876f1e435e8b49924a434b778707d2f27d951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3801c2a6a6df3665f71c0a115b38555c7732f1bc1267c6698fbdf9891cce2ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f9ec02dc3b36272e1b653a992b84dda0ee0bdc0a08be735e00544b076850a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dd563f1351120db9c81d90e546ce8bb54a4dfb30dadbe114f680dfce0d0a5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68dab29920495954fc1769b523a4be4eadefa0b53e0fee77ecbf93b9b23433cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
