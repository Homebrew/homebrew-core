class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v7.0.0",
      revision: "7c70ffdfd9f71a654300a78b3b627782e6abe1b4"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "294b2bb9fa19e6b395129d792fc5880b326906268d4ad023259e9aa9dee85a93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e1586d7240b2e3bfada5528fc18da035adbafdda2a55d4b69a00a272eedf88c"
    sha256 cellar: :any,                 arm64_sonoma:  "3a7a9c6e7042ac3db18357200989a9ee89f730b067593445ec4d556e425a3eca"
    sha256 cellar: :any,                 sonoma:        "53be6dd8eb7dcb6f930653f901c48ceea0602aa4584681faf92ffa35679bd1db"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

  on_sequoia :or_newer do
    depends_on xcode: ["26.0", :build]
  end

  on_sonoma :or_older do
    depends_on "swift" => :build
    depends_on "jq"
  end

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox", "-c", "release"
    (libexec/"bin").install ".build/release/mas"
    bin.install "Scripts/mas"
    system "swift", "package", "--disable-sandbox", "generate-manual"
    man1.install ".build/plugins/GenerateManual/outputs/mas/mas.1"
    bash_completion.install "contrib/completion/mas.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
