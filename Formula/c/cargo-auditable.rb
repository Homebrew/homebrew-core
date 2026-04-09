class CargoAuditable < Formula
  desc "Make production Rust binaries auditable"
  homepage "https://github.com/rust-secure-code/cargo-auditable"
  url "https://github.com/rust-secure-code/cargo-auditable/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "4ce3fefc10d704db496c8701d8b2c8623abfbf5af1c673ff607fd1afa6c68052"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-secure-code/cargo-auditable.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3fce86e8db8ffe764d2ba4316d86dd1ee8ae2947f581e29e43c0a2730e09359"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27346d4bcda316d8618b7e7b88ca673ba24d2df3c0c96c30360af2c2f61417b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9748e63e96fe055d2eac69a31e1117269f69be8052f09e71969802543e47deb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bd3dbb96e21148f93e8f20fa136ab151c325bc850d2e776c2e9781015f625da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df75796af0beced442d90fcf41d5849174d05acabf8b9c282b29ba48aa3d52a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1c83ef6cd06c3df7d29e57937050e2779c90d08d18ff316c422f08a05d4edf"
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
