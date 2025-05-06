class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v2.2.2",
      revision: "7dacbbf3fb9a622247c1b0b9f18a4a9c7673ee53"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4cba95e2f584f56e2e726c7808df195ceb0c1fe20aa3436f126ef0c527c59c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de10dbbddeff1469e06acd6ce7edefd35872fb013b75c55a6f60f8b4e6a15803"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c289261da5fa0e1b120bcb0dcb5ebf7abc67bb014f55f2a346f3ade71d2fd06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff349aa8bb8af56798e3bcfe5344ecd801bc082c1aa6eb68e458a4c7de74b79a"
    sha256 cellar: :any_skip_relocation, ventura:       "dabfebb8a16bf2da2058dcb0f6c6df51d7448728412001b135549802ba360303"
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
