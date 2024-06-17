class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https://github.com/hirosystems/chainhook"
  url "https://github.com/hirosystems/chainhook/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "9afc764a073b40e1598d730f436cf4f2be2c1c1dd3bbbc533cdf1aa4c0779b3e"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/chainhook.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab65909e061bad7b48abb69df1b6d3da4a3fcf297799cf5873ef79960c05c8c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db904c99b8e9bf5ee5cfe387a11d85bcda7c179bdd83298a045cbffa4a07ca74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44eafc1bf1c782f9b15566c98d963bbe85c7f9f021a6b53b8d91812f92c9d220"
    sha256 cellar: :any_skip_relocation, sonoma:         "405a0304cde407273c4e39792777ce889ea1d2b0f2f820192ac5eae793bb9f52"
    sha256 cellar: :any_skip_relocation, ventura:        "6563d3372202560fb91650da2d4043df352b4aacded4036b2236d4b6133c7aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "cc7493c35cdc38e67b410c55328c76c06bdf0901f78431e313b9fd84c4229a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279156fc1cae3d28f450af3554b94dbec9ae0463f9e7c70b0448d0ed3f2d7902"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "components/chainhook-cli")
  end

  test do
    pipe_output("#{bin}/chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath/"Chainhook.toml").read
  end
end
