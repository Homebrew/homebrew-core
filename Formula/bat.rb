class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.12.1.tar.gz"
  sha256 "1dd184ddc9e5228ba94d19afc0b8b440bfc1819fef8133fe331e2c0ec9e3f8e2"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "fe47d61a6eedc6442d4a2b45bb15eadce806102c46247dd866e762fc510f2ac0" => :catalina
    sha256 "c01694ccd70256fe852f5f597ed1ab917161642e1309b367caa537f77f98ebf8" => :mojave
    sha256 "d06770fb4f496a0dfa8294431d65d93c53c4fa14a09c28ca7d87bbacf8419cb3" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
    fish_completion.install "assets/completions/bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
