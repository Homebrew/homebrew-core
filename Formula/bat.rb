class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.21.0.tar.gz"
  sha256 "3dff1e52d577d0a105f4afe3fe7722a4a2b8bb2eb3e7a6a5284ac7add586a3ee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e582eafc63d7242af612bb069f3686ece8828c239232ceb15fa91b374930f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a8a80443ce88c0aee5f734a2c59707c5de6713e88d7054d7791c10130beec0f"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e28f20c861c79ad3d696f597af3bf153a4eccad92968c1b0cbd96edaa83ed5"
    sha256 cellar: :any_skip_relocation, big_sur:        "54b82450955087f9029f74a1d816cc8e099357f926fffd4f9e867e15949be2cc"
    sha256 cellar: :any_skip_relocation, catalina:       "74e48f3a0081f5fe07b7eef3c9f9a4efffbc58e1b682530ad3f4a33a5717e4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0aafc35b964b69f3497cacc5612fe606c5a0205d0b887ff7ddd94b1ca62fea"
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
