class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v5.0.0",
      revision: "9bb930480a19be68452f86246578945e55580312"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ecbe0bd750ed7f2bf43d3c3b3091716da3cc6cc233f37b685f50cf4595a0c9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69260fd9392b375e6cfa8cd4cff52ec7d7f914331270113755d9819eea3d9c80"
    sha256 cellar: :any,                 arm64_sonoma:  "80b838d93d9e7d47c82c4a4ad0bf646c974e256c97d8f56b1269b8bb602848dd"
    sha256 cellar: :any,                 sonoma:        "536f4db556cdf3d412f4873e76fe39018914eff605aa76211b814441e08e51ed"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

  on_sequoia :or_newer do
    depends_on xcode: ["26.0", :build]
  end

  on_sonoma :or_older do
    depends_on "swift" => :build
  end

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mas"
    system "swift", "package", "--disable-sandbox", "generate-manual"
    man1.install ".build/plugins/GenerateManual/outputs/mas/mas.1"
    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
