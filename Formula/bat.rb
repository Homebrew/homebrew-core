class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.22.1.tar.gz"
  sha256 "25e45debf7c86794281d63a51564feefa96fdfdf575381e3adc5c06653ecaeca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26bd8a65f1c64d7b33762df68727667b487b1eb777a42f52466ee5416e57a0b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2e4938525974dc9f791700ff0c908900195cf289c8d2062954be7ce81a3ab7e"
    sha256 cellar: :any_skip_relocation, monterey:       "94b08c3b72f6e052e49288f36c02db0b72f2607f147c31b45311ec2b7c24fe0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57c1a429bc33e419ea0aa5cae8dbae1b32337badb22ea594306bd78e079ff16"
    sha256 cellar: :any_skip_relocation, catalina:       "992f1d749415acf3df041c4f4a5295b21f0ad415f080e3a8ca45791c1136ee35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd7549c1f693534600664fe3c33678c0bcbb0b6e35087c4d6bfe2bc2979c5e5"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
