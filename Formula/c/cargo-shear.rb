class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "3da17c403b45d4a4c1f0547d8f1ee459465510c636f22a59190e449c69fc3352"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9983a0ffd0272b8b381eeceef3481e4a378b4f93c20a6036ae6cc05b72c5f08d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fa68f4f2b59b2739a4b5f0746606ee55e73c912348f3682565d75d170b8bcc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8404f8bc7a5ca8ac54a0f002692bdd468660bc38456c767c6e1e0988e4e9f57"
    sha256 cellar: :any_skip_relocation, sonoma:        "35ce1a5990a9ca7ef74cb336c2b609df650d08fc87c66acd886568844ff8615a"
    sha256 cellar: :any,                 arm64_linux:   "9d8bcc78127e6affe597c67e2653d86a55f7367f3c2ca52e6a2256a58cf7d0ab"
    sha256 cellar: :any,                 x86_64_linux:  "54afff98e6a17a7ecd6543b87ff7f142a547c7d87a9f0ea628d3ce8e05618b68"
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

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end
