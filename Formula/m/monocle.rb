class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "99453cc8f0da7fb2f91241a7e40d643af17562cf8ab2f6a8d4110c01bc597e7e"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d38402f9d5b28dfa11c8d32ad45f19d7b6a21dd9fdccfe3d07bf56b25e539c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ae95d317d5351cd1a3b55a3d37940d859621fa9c3768a35d79a25cf7d2fcdbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3176edcb2f69abae25cee29f0bd1613dd25c762c4da782039ebddf38fcac93d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1168583744200281d51d66d03dc3f66205298d868a4cdd35381b52d60d9d49c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51beff7faadddc02687cde1975be33d3877abf6ccc49a0227914d31d233fabfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654bf71e5532f527bbc7d1fa051fb286e06a7cb44a2288ea72039be4c0a2275f"
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
