class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "72df8cabe398ca98fcb25b583d902dcdf0b1ae79bc4dca20b9baf964933dceda"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9530c068f6516f21181655aa2ed3eba40c9ee854109c6667a5c84cc7760330c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99fa31d8bea07e9aa9c324f10196efa7f13a0ad2f7bd0d3d1c9b07ad3f893c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b15e6e681b6cc28fbd57bf1cb52fa8ab26e07d885df447640afef61017e7663"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa1a30cd9453d59eefd229c70c3fe6b6bb7c4fbb1134e6c6fa97575db46cf341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f7e541c75e45353dca385cec8b42c103ff3f02f1eee18a8eda7a0885f468842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a0e4b69088ae9fc5a2fbac746e4cd4472c1700344d28a85222527fc07b57d3"
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
