class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.1.tar.gz"
  sha256 "e907a6e98de63943fb4063b64aba5a7d3ff88748858ad141333d80d8f4ad8e9e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "069324cf3e9b3026479f047709b35dce58e400a182e50420b75f6662b2aa1e91"
    sha256 cellar: :any,                 arm64_big_sur:  "4edeb2801a99eb07b424ac485646a1f7721ea5e35468badb11dc56e3d815d385"
    sha256 cellar: :any,                 monterey:       "378b0e2d0cf7128a58e5e2a848a2845496ecef8ffcc013c7c6370c1f663053f8"
    sha256 cellar: :any,                 big_sur:        "a2f5a47df57bfb03009bf2e13038ff77c893210bc9d3c582063e09b14dcb42f5"
    sha256 cellar: :any,                 catalina:       "ad60a8920b548df7fac95e8f8999a376add7a50c886447ad1946e450cc61a358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f05db455cd2ff051eeeb34a38b3ead7d3fc10340cc8eecf3350397aac2b756"
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
