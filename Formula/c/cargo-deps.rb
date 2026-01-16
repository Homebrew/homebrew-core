class CargoDeps < Formula
  desc "Cargo subcommand to building dependency graphs of Rust projects"
  homepage "https://crates.io/crates/cargo-deps"
  url "https://static.crates.io/crates/cargo-deps/cargo-deps-1.5.1.crate"
  sha256 "958e78d8463edf62018d7d5e6f1c5866d59084a4f224c3be01f6eca8a2d3df47"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0822ff6250873cd04ec984afff6d6ca66363496d268d8902dc406f29bdafb403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6817f6aba18ea54427289043559801aabc573370c80aed691e9ae78893046348"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbfa6ef183d5a237a74186f332915c4704ce9926be46f30bf67d21a93443fc50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e3032013ef5a554be4c6c0d1ce750a863cc8d6ba0d5aeb631bac9f96dbe832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a439a94c145edf47da3e56d8ddc476d7d70e6f02e0e25bb62b5ef2436859ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "faf4a08e986ea2ae4c5da48d6b92237a1cba2a5493c807b50c3a4f454555749f"
    sha256 cellar: :any_skip_relocation, ventura:        "dac2b73dceb1fd9ac07d9ef73b5c087c909c11af4cc67965be784628c2aea806"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0b24ef58ceba9d2232c3ddf0f826b94c0a9347d0c9bc84055c1445d57a9972"
    sha256 cellar: :any_skip_relocation, big_sur:        "524f11ed7795845ff1014f495a783b0c3db46900b14c6e7490b093fbe4656308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "205f88a20c0bf8fdabc555ecd1ec72a6103f65dcaaf5dc8c23f687e6d78249d3"
  end

  disable! date: "2025-01-19", because: :repo_removed

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

      system "cargo", "generate-lockfile"

      output = shell_output("cargo deps")
      assert_match "digraph dependencies", output

      output = shell_output("#{bin}/cargo-deps --version")
      assert_match "cargo-deps #{version}", output
    end
  end
end
