class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v2.1.0",
      revision: "a4756e8c82a2bae5d5de1b137ec16fa7c1df8c94"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f42e337bf806d9c55dc020fac7769f98ab033e1ca7bd22cf7fbdfb3010d1a8db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab3563b0598e9ba16c6641792319ec0ee65c89d0d086d323a628ca07e26c9286"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60da702231aa9894a9f95b580130f62285fd84658611d01c93a2beea7431774f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9443ab044f86178b718f669ccb5601116829686b1cb05448cb231b63f249e809"
    sha256 cellar: :any_skip_relocation, ventura:       "f46a11b8667581487e13b786d349545cfa2cc15e1093abf4017dc6aff4cc654e"
  end

  depends_on xcode: ["14.2", :build]
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
