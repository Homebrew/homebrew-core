class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v5.2.0",
      revision: "e84c0658e1dfff2fd1eaf0fc8ef338a2a99b8f67"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04aad750ca8ffcd7e7f5b6fe13788380ba7ca5bb7e2eb76371b406a2737f2131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059e622a8c2e1357d848b20e3588574ff6cba20cada084538a4ad100a319127e"
    sha256 cellar: :any,                 arm64_sonoma:  "592f44233706e97cef40c4e90717a1bb47a5e44a48c13f93d7c34a7034a57e90"
    sha256 cellar: :any,                 sonoma:        "13938399be5ecf773beb77258b39ac95af336a1bf9e84fc0ae750acad7f19d51"
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
