class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.19.tar.gz"
  sha256 "8343e8602eacea45ba772904a0e5aadf5d1a8ada72d5df7f2bafe88f1ee471be"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "345fd560e960741f35d575ec2626934426f7c215353881fb7a2a13f913d9d2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13c4a7d97bf97e1110d48916d1bc596d7bddc372e5f982c9e0c3ad2b9eaa3cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17390cb9cbadad348356110f4fe078aac77c4b0ce2e602fe4dac7b6e810efe94"
    sha256 cellar: :any_skip_relocation, sonoma:        "b34cb24be5a81d900cb7c4368a2330df5c36e6d7e4edb871a05a6d60745a5fa1"
    sha256 cellar: :any,                 arm64_linux:   "bce520f46ac96b05aef4da330ef5587ed4d7798bbff6cfa25887cacda84fda03"
    sha256 cellar: :any,                 x86_64_linux:  "b185bc0ed15af4ffaeed4380ea9cb4afb375c51341784cfe2d04b76837b95612"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
