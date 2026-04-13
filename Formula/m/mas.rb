class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v6.0.1",
      revision: "535562b304eb110700eb57f289317f7b5c41cb2d"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "230f3f2b181f34401a690183ffe7ae26b038252b7a43a07bf49941fdcfaa4f56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40865540d35bab88be3b08906cbad8c529b519c4fe424f4584ff1740d6f781cb"
    sha256 cellar: :any,                 arm64_sonoma:  "3b8df47fd3a3cc15e81475337e767a779a505692e169c09a8f556cd12f8473de"
    sha256 cellar: :any,                 sonoma:        "127de59def45b51dae56f74280a21c807e7c4a670e2c8ae00c4559f2c21fdaec"
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
