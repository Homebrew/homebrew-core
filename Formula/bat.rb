class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.18.2.tar.gz"
  sha256 "b176787e27da1f920b655bcd71b66c1569d241e2272bb9a4f6a64e6501c0cf2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bd82aee26364ed994d79c1b43a7eb86182b629c6cf90fd9ff6f10cd72281019"
    sha256 cellar: :any_skip_relocation, big_sur:       "b92107a4795c548b9465863a4fa22f4a65dd169a6f264d01330ca09b03be8452"
    sha256 cellar: :any_skip_relocation, catalina:      "642aac3982e087d39541170de8b4ea3db9b363bacc207c84c12d1a8ce37296a2"
    sha256 cellar: :any_skip_relocation, mojave:        "c3bf67bb260d75735f019a8ba57e816fc9145fda4e84d30db93ea4f328c0c3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b307f4728b63ab3ab40ef9f68961bdf27abce513e1382f7a7883008d258c9b"
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
