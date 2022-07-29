class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.10.4.tar.gz"
  sha256 "f4a6d94b48b27b6db7bd27d6091f0c9aeddf224c8a8dfe31133750530f096890"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2fafe0a44e4f4e50654c56820900e93828cbef571bd3475709573a71ed775a9e"
    sha256 cellar: :any,                 arm64_big_sur:  "61ecc82776a996b1ca388187c1b9de5a5a00ff8df7da6abecee8a47aaca8dde3"
    sha256 cellar: :any,                 monterey:       "971c3b80ab623e902f7bd2f42dd9575baa40b639f06ee54e99bf1255be1cad6e"
    sha256 cellar: :any,                 big_sur:        "a2abc5bbc835bb46329762d5841b607835cce4d1d7aaa8e9bf16a8521d0649a9"
    sha256 cellar: :any,                 catalina:       "23d5a9f40b49df37b3a1a71957230ef0a330490637f2e80d87e064da61ced395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ab9905c7b94e991b2fb74f8a049f775a0c1d2d2f84e5e808abd64a6fea0e8a2"
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
