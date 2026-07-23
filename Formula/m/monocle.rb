class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "dcfbc647a13336d725a78138769aaae5056b27205e1fee8f08275f684c78c7f0"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fba342be3fea7807d6845a25ecc29467bcee85dfbe046c12fcd8ae0a046b1c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8e199725e3d151656a6b420d8a7f65a5169535eba7390c4fdf48c02d6105a6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8564de09ccd51ca994355c7fc1ef85bc88d560da44f3e3f46ec88cd4c05ff392"
    sha256 cellar: :any_skip_relocation, sonoma:        "a13913fe25231becfa3f7b6326367c30dae4efc87c3ed871a9ef8bee3f86c70c"
    sha256 cellar: :any,                 arm64_linux:   "f5839ab9dc7d89b71566da11752fb177461d9e2838f77ce22d21533423fbb88d"
    sha256 cellar: :any,                 x86_64_linux:  "18015e14cbe7a7c5277bbbf5fdded6a1cc8c82ac6ac9124851151eb07cefe3f6"
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
