class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.13.tar.gz"
  sha256 "fc8c476f3ef1a32b6fb11db2c365fbea25f1face73d1df9ef18318d4be294006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89d2720f711167d40a4f7a972647dd6a95aeefed5d8d7cb8b3771c1598d5ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36dfe29b73d0cafc0bfa51fc6ce5579f4baa772d059281c386468b4a06be8980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d5b8ca40f21d7bda60c61cb92fe5091885589b424bb47e5f3a502c34a8e921"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a769690da67f50c85efc392bf2fb6eb5c460821b14e8cefd21487935651e37"
    sha256 cellar: :any,                 arm64_linux:   "21ef79781f2f37d0e88007a444db547cc68f77bd893645811c31ec974b2c6c47"
    sha256 cellar: :any,                 x86_64_linux:  "f0ff81adcc0ed06d32456e4825a030de769d7e0ebb5db7f80a22aef7af23bb17"
  end

  depends_on "pkgconf" => :build
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

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      TOML

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate/"Cargo.toml").read)
    end
  end
end
