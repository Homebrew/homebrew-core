class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.4.tar.gz"
  sha256 "e8d1a6d36206e22ce42130be2da5bb2e824689a64779ffb007b6f8e5bf1f24bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fbbd73c38eae6f33eed440855bf855493fcaeedf5c9f8c83c4233013094b1546"
    sha256 cellar: :any,                 arm64_big_sur:  "2bffcd762c73459a0286fbc4397e6fb5bbaa0671805be4ac311795254f286939"
    sha256 cellar: :any,                 monterey:       "92c433889108bc5e2e789bab0bfee9b9cfafa552ff20cb1babe8b279c4de490e"
    sha256 cellar: :any,                 big_sur:        "56a9fbc8de3af0200132c55a7a3eb51142601ba0551030649bd2c24d7b94f9f9"
    sha256 cellar: :any,                 catalina:       "7800fde8aa1edce26061c8586df41634b86c2ff4a7740218ca930512e8e4e9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89a3bbbef827f4766d7fb85c19e384d47108f604a508aa916d8cc343e9ac251"
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
