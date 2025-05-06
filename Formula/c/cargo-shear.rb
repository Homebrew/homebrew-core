class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "ae097e6a9c59834d37568bbd94b0a38af6771bec8c837624411e4214458e7ab1"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db5c76d9069d9f616b1140dc846d2217f382a841e7ce9507877002aba99ec631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d5b35fb81f84bf6f2c9ef396ec271fb7eb6cd7a2c32cc04689472e0fd242814"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e920a7a087d08eb4d6ca2cac31d76cd6fb58c80963ab57122ad8d52ada50297"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ad40cd3b56694a0d5c7e92f36845181e72b441eb74b5a9c45f9e866ce9d23b"
    sha256 cellar: :any_skip_relocation, ventura:       "ab69afdf569117b275de57d64ca9868e0bc3936cd63c27c41a2ed5d56b1c48c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2866c338b0bb74bda24fc2cf8f2d13e08206ea7774170034f6550cbfbd78b60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b04c023900e3b4c0ffe803f235ec36767df42df04e7298be959c09eb720efd"
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

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          bear
      OUTPUT
    end
  end
end
