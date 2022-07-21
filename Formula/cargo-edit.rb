class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.10.2.tar.gz"
  sha256 "44a3507a0ba65cc7f740b1205023f351b1c4bd03f7d5a7ee1e1037a82683ca42"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b6c26c32c8c053053d42c1a1b5e3927a7540bad7017218713871a1bb59b790fb"
    sha256 cellar: :any,                 arm64_big_sur:  "a447fee84c21e1504ff0c074f0eaac4a63dfa82192a9700fd0953073cb9ee4cb"
    sha256 cellar: :any,                 monterey:       "e424c914ae98dd37942c9c2da00a9f4847afa1c643b606148275d6c00d0816f1"
    sha256 cellar: :any,                 big_sur:        "e04fccdfe40a3ec79132c952aa1896b5c3ad21867691ece0a0aff22e801ebff9"
    sha256 cellar: :any,                 catalina:       "f70be8da01348e5344f9403871500f731cd6c2bb9a401c081fda812cac0b70aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c55893ef736d2f88ce7e2417f11751bc321c76c9ca889cc117347bd1d22c98"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end
  end
end
