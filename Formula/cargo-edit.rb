class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.3.tar.gz"
  sha256 "fccee9fd2d9ceaaeda9543272874ea723e920e1c3aaa257086c9b099a61c675e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d0e7e4402d55e1420a1faafa1b0bf14e5515e8343458ad84d9a266b9d4be361a"
    sha256 cellar: :any,                 arm64_big_sur:  "e625d27c2a0474ebf28cef8c5ba7c316a209ada281476f5f1c304fa7663e19a2"
    sha256 cellar: :any,                 monterey:       "4bd81c17212db779a063f9be5c0db5f0ed86316b93ebd30a84de740b4d3931bb"
    sha256 cellar: :any,                 big_sur:        "ceb2ef7b34b46a9a82b1bd0fc0c4f141f9ad824248405711fa43d24e12184783"
    sha256 cellar: :any,                 catalina:       "7c79d87fa1932db1f5b36747087f09df9e44b17340838e6e633eb8b2bdf45d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1db9d48295c151186329e2222cdef3113f561a017de15d3628606b2aff5ed395"
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
