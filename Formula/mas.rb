class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.5",
      revision: "9da3c3a1f72271e022f02897ed587f2ce1fcddf3"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cf07ace9600aaa0ffc10c23bb9990505d1966560ced4bac988f77006421aba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2826df27bf71c4a1ddde0cbab10b61722d8e288ad05857d7ee25bd7bd36c83a2"
    sha256 cellar: :any_skip_relocation, monterey:       "00cc26f6008ec18abd114cc4867000c531cbce01230d926873a461da9dd65347"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b0b015fb1369189534180966db1213bcb46957a2d971ba47d4ac539ac219d4d"
    sha256 cellar: :any_skip_relocation, catalina:       "a803419d974bae91e6a17c29268aae5733351fcac14f1154c8b30e5966d5e4d5"
  end

  depends_on :macos
  if Hardware::CPU.arm?
    depends_on xcode: ["12.2", :build]
  else
    depends_on xcode: ["12.0", :build]
  end

  def install
    system "script/build"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
