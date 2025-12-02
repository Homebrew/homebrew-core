class Matcha < Formula
  desc "Daily digest generator for your RSS feeds"
  homepage "https://github.com/piqoni/matcha"
  url "https://github.com/piqoni/matcha/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "239f97bed3014c8809d3d70c7840b77985c7cd12dc73510ae7a2fe3f557a0e1d"
  license "MIT"
  head "https://github.com/piqoni/matcha.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c890cebefafd0d35f6adff006bc5c8cd0675d49e5d9bbea2ce2822bbd1e5b57e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c890cebefafd0d35f6adff006bc5c8cd0675d49e5d9bbea2ce2822bbd1e5b57e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c890cebefafd0d35f6adff006bc5c8cd0675d49e5d9bbea2ce2822bbd1e5b57e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a9798b4104d435c462561b8e0414f679c006d9bb3b2905b975e1227a9d5386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64dc79f83c0f24a356e6b84c0f297c1a79363df04650eebd223f59eda68a342a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0b21648be00ca66fa713290ba70b1a3513b64e723351d8e37750d0e96aa4643"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Hacker News: Best", shell_output("#{bin}/matcha -t")
  end
end
