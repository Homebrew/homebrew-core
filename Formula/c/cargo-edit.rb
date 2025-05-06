class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "df53ad2288cb9f9ee3ebc0eea389ec14e4e0fbf9cdefda75e5b0eedd0a550be1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5be403a9d73e9a2d7b5ec95d069667a813a3dcbb8ff687b26cfda33697c9399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc2b1ce0900e9c8f194d69d0dc2b16f0c87f4237a94fc48fad23d24567f2e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed3d0a080dc043f81dee1e0326ebd60a323540b724c338706639c1939297d4f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "23bf54f34ce8ada9f79ffadc59a86eebac2f0415f58df832d65fb1e71408373d"
    sha256 cellar: :any_skip_relocation, ventura:       "ffeaf27cbde3d20afbd3a082cbec77993d7c1c3019fed5573e571cddb9f28c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b725e30c9cdaf9b90537f90ced1cefef7ffa7239d1bedf6c74209ecbfc606376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6a588435811c6f563bf536f72408959215cddc77cea20f078fc73eceeff8343"
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
