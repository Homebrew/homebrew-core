class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v2.2.1",
      revision: "92cdd8d24c14f72f801f86f03a4ece1b376b0145"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045823030abcfdeddcb1c64103b33617a0fe8c41fbaa2b81528cfe6b1a6e3894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "791ed782d7c9b487055a4be6cd22ce61b8a98d64f23fb956e075063688afc7fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca2aec7b188237677be38ad30556605c83923fa8b249e4588ab43ffc3e9ad978"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ec615af77f46011b15fbf120edfcad16f6aa2fc8168a2422e7614e1fafa6a47"
    sha256 cellar: :any_skip_relocation, ventura:       "26b98930cd2c2da0587f4715ed1905326d95051911f60160a0650bc0ac43b208"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "script/build", "homebrew/core/mas", "--disable-sandbox"
    bin.install ".build/release/mas"

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
