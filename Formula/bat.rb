class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.12.1.tar.gz"
  sha256 "1dd184ddc9e5228ba94d19afc0b8b440bfc1819fef8133fe331e2c0ec9e3f8e2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dce7de3c210949e849e65e0167c343e7145bd664f90e85d0f0a7f024155e3409" => :catalina
    sha256 "b6e77c28390e81b73a02a1b6e10910a306b30ad5f099b9be91ad1f0252236b26" => :mojave
    sha256 "6c4eeef5809399549a7f8d5499eefe7b2686ed86ab003757b1cdd51df2297fa3" => :high_sierra
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
