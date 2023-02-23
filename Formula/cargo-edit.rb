class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.9.tar.gz"
  sha256 "46670295e2323fc2f826750cdcfb2692fbdbea87122fe530a07c50c8dba1d3d7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f2ab48fc705618eb02a27722a41030f3bf1366bf3b81f4ba76aad74f56f1c25"
    sha256 cellar: :any,                 arm64_monterey: "46bd85b6c532636ac3dba2437aea0c833a9eb74096086dc027bfccf00ad57da2"
    sha256 cellar: :any,                 arm64_big_sur:  "e1f709204d84e116d9e1b0369cfb665587b7f091f66252fe6367252913019bde"
    sha256 cellar: :any,                 ventura:        "4a090755b81356cac9c2142da5789cde9c486a7af97a413451bfddc693dbc315"
    sha256 cellar: :any,                 monterey:       "a19a3e393838fe2530f01f3a29341ae501c688b3e74659972cf941938f3135af"
    sha256 cellar: :any,                 big_sur:        "6210e777b4d4dbde779229db4da1e44f6367420d686a82d2b10fe88725fdd79c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b696c83afa03b566563a8b029d82f09a6ee4f9a52b70164b67023c554869870"
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
