class CargoInsta < Formula
  desc "Snapshot testing CLI for Rust"
  homepage "https://insta.rs"
  url "https://github.com/mitsuhiko/insta/archive/refs/tags/1.48.0.tar.gz"
  sha256 "acd7140f00155f3fe50b723296fb828dea9de68297f3e26f8a7e442bcc62fa79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b48fff37f4381671d507159a9cd4122857d3ba888fa8c6dc17b925cdb5341174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6a9055ddbc17aae68feece40ace6a57be0677fcbcdd6339cb0d9d55b49bd56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b17ad755ae64ce2ca35e18362ba9e123931668347d01fed461c94bf77e31ab9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbc9eb83989f9f6e98744b16424d2d042162a8a303b272cfd63d8ac7f60b7fb0"
    sha256 cellar: :any,                 arm64_linux:   "9fdaaa8b6a695e3535361b5870138c878ef5a91f20c0bd2e6aca03ec0780c272"
    sha256 cellar: :any,                 x86_64_linux:  "3360339dadaff05b5f0d9de7df6868e952f823cc8ddfa38942d44e544746bda8"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-insta")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-insta --version")

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test-insta"
      version = "0.1.0"
      edition = "2024"
    TOML

    assert_match "done: no snapshots to review", shell_output("#{bin}/cargo-insta review")
  end
end
