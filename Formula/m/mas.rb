class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v3.0.1",
      revision: "67e5dfd18882ad294c58441f5d2308d4dfccb862"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae10a5a0d268290095e2974c5f55a183ead471def9c8abb95c9b776e1be27743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de27da09ea41eeaf8096fad0bce5abf34aaeee80ff3fe0a23adaa301874a434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b25f39c6267094e3fcfe477a252611a85bb58fe263691224e6d699d6dadd006"
    sha256 cellar: :any_skip_relocation, sonoma:        "7046b5239d663697d60d8a5e6266a0f6702368dcb4eaeb614a0cf05e1b890bb4"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

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
