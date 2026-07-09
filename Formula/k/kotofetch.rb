class Kotofetch < Formula
  desc "Small, configurable CLI that displays Japanese quotes in the terminal"
  homepage "https://github.com/hxpe-dev/kotofetch"
  url "https://github.com/hxpe-dev/kotofetch/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "0e04bedde86fcdd05b41e15211aa8459d24d347b3e45cf030383f5b650c01bf4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386d70b8f47ca75f06ee44f76e0b022035e4b1a80794665006eac0774a184d5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f2700d0d9ef1e00b0f4d63c7407b5dfc3e148a45c0bcfa85f8418a4a743ae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97fc864c70aa5201ce2b368e4293dc42911e73722c75f7030a53271b1bd34b68"
    sha256 cellar: :any_skip_relocation, sonoma:        "7534b23904397208fd5aa931fb7398a67e986fea9a30c53deab835e8be452da5"
    sha256 cellar: :any,                 arm64_linux:   "266dc5f694c4eabb7fe9f80fa15b5e8235cd23f06444ed404c55c4dd4577d564"
    sha256 cellar: :any,                 x86_64_linux:  "a7a8bd3790f2d950df6dc30745b0346e46d4afeb32c5afe484210a22a84fbebf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kotofetch", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kotofetch --version")

    output = shell_output("#{bin}/kotofetch --index 0 --translation english")
    assert_match "Fall down seven times, stand up eight.", output
  end
end
