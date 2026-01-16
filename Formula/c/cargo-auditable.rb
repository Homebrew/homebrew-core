class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "61d780d55dc35e4ab9c9b6dce744a35a03754c128b3a95aeb76f83c397807fbd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf27e595eb17b847d4cb23f36a349a906d6eeeababb551338bf9b67e0dc55d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "879c9833ef58f5d61e73134eaff542bf5683436a7d0871b0049803ec7b8a143e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ecc61e268d1c72772e50b85b8b57fce958dd45dde8e2d021eec61dc5aa3590"
    sha256 cellar: :any_skip_relocation, sonoma:        "f14d4a3c2f452b3959ee11dee9c367d2c80d0e75a9a0d782649a301e14dd7b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b6bf03bedcc15c00735f0a1029fca72de783cc5a23f0d5c0d425c480e076768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f10cf1372abef1e42db9259246c6643eca1e0d628b673d6ccd1cd01313d3f176"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-auditable")
    man1.install "cargo-auditable/cargo-auditable.1"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        fn main() {
          println!("Hello BrewTestBot!");
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system "cargo", "auditable", "build", "--release"
      assert_path_exists crate/"target/release/demo-crate"
      output = shell_output("./target/release/demo-crate")
      assert_match "Hello BrewTestBot!", output
    end
  end
end
