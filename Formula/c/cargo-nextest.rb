class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.66.tar.gz"
  sha256 "2525fa66c6945821fc5b957b5cc41922c6879731bca8711f577f8794ef0b389d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c02f33fe1c3d8646f2a9785763eb11cfb4938704e665cc2a4b1865152d8ee198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e033e28740a64125d170fe8bce552a4e54c897d86b9516448101cfe00b25d74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd49b2dc4b085cc0fef56295af4ea2751cfdb9ad8c2f9f3d7e368d4400252361"
    sha256 cellar: :any_skip_relocation, sonoma:         "435fd537c955b7f05e5f623cb858906d9fe637126ea520fad4e2f55bc63d2a6c"
    sha256 cellar: :any_skip_relocation, ventura:        "4605270d2ffb83d79bc9f41fd9a3bb291922ce3aff9309d7a002f0ce043dd9b4"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d31b541f62583a12d9eed0d41abb79e685d7bb7ad2aa4b4af3a38771f36d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d60aeaa08a5ae955a0829d735a3afbaf6d03723f4efc0dd539b38aebffd41abc"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
