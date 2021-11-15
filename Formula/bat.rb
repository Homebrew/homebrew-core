class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.18.3.tar.gz"
  sha256 "dff7fa5222f40c7b3c783d3ceb0c3ffb35662f1198b00d785f80f3f1523399dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "514d6f72487bb11a7f067e5e7e15a5a7d4ff4986ea384b5629769339724e8acb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6edd4db8dc910dde6552aadd68af8933d1cd4b8268a0fcdef5795294de59ca50"
    sha256 cellar: :any_skip_relocation, monterey:       "c13493630b846641034369d326747ffc6beb6819feba745cf717267f2fc9ba22"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a075678316a795840e43db540d7465d106860c1db0153d2cabac285dca83fbb"
    sha256 cellar: :any_skip_relocation, catalina:       "0a8ce5ab853f1408966e23718b408e655b70b2d5d6c3b2ebdb0159eee389f6ef"
    sha256 cellar: :any_skip_relocation, mojave:         "c564416a4de6fd26eaf03029a1afd47edce0e49919d0fd2821cf3d870ee5f91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d4d8521a1287dc2fb2408d590e6f113b62d5cb430add6ecb3531b856625ffa"
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
