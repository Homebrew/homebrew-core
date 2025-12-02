class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v4.0.0",
      revision: "21205c013fa941e89463e1d8e553d6e4e3eb8b3f"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acf4efa41ce9fc523c1abe24298b2194ce633b9790bc89210b5c81e7dfb11cc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b12eaa7725b628e9d14ef0d03df4a5580225d14da86c623159ff539a0d6cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aede8a124427ccbe1103b89de25c62c2409272e874eb6f9bb6def619c3bd37c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9005575e04c459782434b97e9183b090cbf0da2a494d5a5d2a6704b0c3493d1"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox", "-c", "release"
    (libexec/"bin").install "Scripts/mas"
    (libexec/"bin").install ".build/release/mas" => "mas-bin"
    bin.install_symlink "#{libexec}/bin/mas"
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
