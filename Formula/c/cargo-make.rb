class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.23.tar.gz"
  sha256 "10fd79354d28e87e579bbd294fd8770c9515f496982452117801ce2799d09247"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac6066ab4e4709e261a722aa3bf0de9d1ddf0361d795b2132eee1b4f323f443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a473d2c5cbad534be22e3b6052d446d455c81600f288fcb2f2a817e63724e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c6519f708ad5db91d72180732ef1bbe791aada8656ac747815fae76d44febbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "99ccf9c285425753e4a6d610a365b8d6fabe8a25f887f83861e1345456a974fe"
    sha256 cellar: :any_skip_relocation, ventura:       "6f966e07a312cc4618de1b030ea002fd753a03c167ecc2c68425d228b247b964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8792d91b502aca03ab9551f6d3f2fe65af542a0d6702b7de4531a130fe7795d5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
