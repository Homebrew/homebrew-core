class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.13.0.tar.gz"
  sha256 "f4aee370013e2a3bc84c405738ed0ab6e334d3a9f22c18031a7ea008cd5abd2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a3940396b74afc976f97c19194dbbdcbe93268f6eb657fd4b3422ce60f03e8f" => :catalina
    sha256 "67a235ef3a22a87d17333d44f547146b2d0c13fc1ec9b076133770b565176f51" => :mojave
    sha256 "1dc30e4059defc1475a2969236fc058a218561d930ef3d7253f53f271d0f4c40" => :high_sierra
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
