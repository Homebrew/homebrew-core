class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.3",
      revision: "aeeb1c508e98d657769ef4e368a113be7822d92e"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6498917d8d2106fa582aa0fd0714cd87ad7d091023c7b3c6b2db3a6051a2fb5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0116c8f800780c890dc819ff3479640f3b33ef235af9fe0bc7a53202b35c9b82"
    sha256 cellar: :any_skip_relocation, catalina:      "015c0e53aee08c429ff468fc2a9c8b0bc973df084c0e6366d92905714f20248b"
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
