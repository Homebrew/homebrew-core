class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.12.1.tar.gz"
  sha256 "1dd184ddc9e5228ba94d19afc0b8b440bfc1819fef8133fe331e2c0ec9e3f8e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "69b83d026fae0b58df9da63945c425dd79b61058616927876d8c63dd1b259901" => :catalina
    sha256 "48571265a7f423c1c215b19fa6d25cfe672b824be6e8b5c0509d7c10e8bcb090" => :mojave
    sha256 "abe522205c991053ef3a057cb3132ce65961695313b6e93eb300ec9f37169c8e" => :high_sierra
    sha256 "d6f857cfa36041c0b627bb9b3e874b29e11436a98e9e341fb1c6fdacdf305405" => :sierra
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
    fish_completion.install "assets/completions/bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
