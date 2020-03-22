class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.13.0.tar.gz"
  sha256 "f4aee370013e2a3bc84c405738ed0ab6e334d3a9f22c18031a7ea008cd5abd2a"

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

    # In https://github.com/sharkdp/bat/pull/673,
    # documentation and fish autocompletion got parameterized
    inreplace "assets/manual/bat.1.in", "{{PROJECT_EXECUTABLE | upcase}}", "bat"
    inreplace "assets/manual/bat.1.in", "{{PROJECT_EXECUTABLE}}", "bat"
    inreplace "assets/completions/bat.fish.in", "{{PROJECT_EXECUTABLE}}", "bat"
    man1.install "assets/manual/bat.1.in" => "bat.1"
    fish_completion.install "assets/completions/bat.fish.in" => "bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
