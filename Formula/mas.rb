class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.2",
      revision: "2f2a43b425498f3cee50974116b8c9d27adbb7cb"
  license "MIT"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1be3820e630aa31911100619f299b7d6b56349cc7298555ad3a7198c8846d79d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c0d556cbae91f5770e1fb04fead95922e0931c4c897a1b940aae0347ff0e680"
    sha256 cellar: :any_skip_relocation, catalina:      "4fe1a0f7fb506a65578b4f25cb6e9b9c40cebb13ed61941f6d41e69a04b97a7a"
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
