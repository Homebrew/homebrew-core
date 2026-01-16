class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "3f0352b8d1ae0f6b778c50103a6877e98772f91783d776643f74041eaee376f5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b141007885bd48b29b95d520568ef6530cf2b5f1b12240c37db72f99761bbdb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21317972556371a52e8f2b036339baf8055e9b11a5c49c686809926991eb197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68e849f0b7dc34ee5ff08c25bd5c8ea7859317be046f89d3780dd277d922883b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8378775a5403d57969dcf037d9ac0061cc5c3dad764f3b39a971105f19ed7117"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe8639d02e0a7f56f36bdd0542be2dec4f4fe2d510d6a056cb00898496f926f"
    sha256 cellar: :any_skip_relocation, ventura:       "22f6daf72369124d93eecc42301be82a47a9eeebbebba9dce6c0f6a59bf1779f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a66361ce4f11824e8bbdf8414fb391310b59165e73d88a5b773656587da08c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "861e0677aea3b39d64cf6b6b783d0ca05be27b3f56a5db8cc39f478c925ae0bb"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-sort --version")

    mkdir "brewtest" do
      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"

        [dependencies]
        c = "0.7.0"
        a = "0.5.0"
        b = "0.6.0"
      TOML

      output = shell_output("#{bin}/cargo-sort --check 2>&1", 1)
      assert_match "Dependencies for brewtest are not sorted", output
    end
  end
end
