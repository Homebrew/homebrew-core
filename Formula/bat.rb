class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.12.0.tar.gz"
  sha256 "7a3d0d94b6bffa00644a4afbc5952f87965f4723de3878b97ef8b7ebfd912477"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f9cc996ed6701f12cb9f8b6b83893dbbd270cb3c72611bc06c776d78237c99c" => :mojave
    sha256 "45fe9f760a993fe4a7e49e0bd172b00120d3bfa514818e78764082e8b2ca7a62" => :high_sierra
    sha256 "aedbe583c7bdbb064cdad93c2c44422314d73c3f08918a1c284e195c4aa18937" => :sierra
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
