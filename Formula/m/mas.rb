class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v5.0.2",
      revision: "9ba2cf5c435251c8459e55d7228c4ef896ed0e4f"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c1e573cfabd3269bc752a1a16075cce8872793a5cf1d994b984a5ca4f363adb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23519ffb411cd47dd21b16d51677d9e52419cc6860ee59f67bc452f990675951"
    sha256 cellar: :any,                 arm64_sonoma:  "ae464d0f74a50e0b782b7f074796ebd68f0513cbaffe12410a4be1affbdadcc8"
    sha256 cellar: :any,                 sonoma:        "9b678a6a15e6048b097fff3f4250d7a2c8ae18e87c501e3318921d498627617f"
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
