class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.19.0.tar.gz"
  sha256 "6a920cad1e7ae069eb9393f5b6883e0a7f2c957186b1075976331daaa5e0468a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa858e2e27ed299915da9127e2ae6e66a49278a36296568df7c3454f6432df2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7877e6a2b8e52c37578f5691e3b42d4d9ba01d87e318343f8c9e3b20590d6363"
    sha256 cellar: :any_skip_relocation, monterey:       "ab108587ccac99048680808eb19034d6b9ed3281242d30c6c16e5c5f50b60de2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d51657ef7296954bd549277f4044b6a614f9c1cfbd13049149adf6f092ddeba"
    sha256 cellar: :any_skip_relocation, catalina:       "e17220c27f33d7a0bedf7d4faa3be066c3e1b358b246ccb4fc60a293dba92b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0122c2fc723d56aa0bda0d8559000301e1339ac7c7fa96336deb3e345ee62704"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
