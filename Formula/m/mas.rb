class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.6",
      revision: "560c89af2c1fdf0da9982a085e19bb6f5f9ad2d0"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e49511dd1283813c4420aec9fc3b3167d18f9fdbb51d82b1e479b628d5312342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "379d46e2657be295321f1603dc1df28130ea0b5b264ceb192a9ba488d77c7a98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "918a1484de106940f7bebc936e1ded87d7b65652054b09204887ad0651937ec4"
    sha256 cellar: :any_skip_relocation, ventura:        "6ef7788e28c46cdc0f916812f49dfeb1fabf2240a8c36f33ce34bcfb9df1502f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b313f2f66d028cb7782c108d6e502ce73ccb9c08fac3bece0b057fcce5c4689"
    sha256 cellar: :any_skip_relocation, big_sur:        "50b50f51219143fcb69c730b52b74011a76104f66348ea727d0200f7b375ae25"
    sha256 cellar: :any_skip_relocation, catalina:       "d241d3b9156b033f3d2c31684a44de726297e07fd9bd5e3ccc4c36e4f1c3baf3"
  end

  depends_on :macos
  on_arm do
    depends_on xcode: ["12.2", :build]
  end
  on_intel do
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
