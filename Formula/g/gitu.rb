class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "c33e0a472aa63a76afa4b574501daaecb2081144f14f5dbfa891bcc939089281"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8af2ee612f11cc86a2b8315dd3887f1084b82255ea7dc98e1ba48e699a49a838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "398bf95af041a0e0619f1e53403fa2b30c6f40a842d7734837d56d6d85d1c032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ada85ec003ce6cc6335425c1812a79ec8142123557309ce452adca575d235549"
    sha256 cellar: :any_skip_relocation, sonoma:        "716425a9eb9dfbfe7753feccb7e9b4dc88663a34002c247387c0ed8ae74d18e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845f58134aae1b13d72fb85aecb2f093aced00d02577442c55b75ded14754170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5ce6a11be82d6b37eb1dede9b446bf379099a0ed30f6058a6482f4d1cf4e10c"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end
