class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "8cedddd7f8ebfea46fa7369a89f6be2905c4bbb9c9430a1057df9d048e9548be"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b72443821c8288e4e12cae5ac2448b8b7988d4c66232fe54a02a62f3a596c1e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e81ef3e948cf57ed49201fc33629ea6ec455109fe762373a9d54e583272db2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc92e7709cac8c2dc19f4278c5aa4db3e181f08bb829f6fb247f2b30c8080cfb"
    sha256 cellar: :any,                 arm64_linux:       "e35592f2c062b0310e0a8403bdd536fa6ca2ee7d0b2bbbd0763aed2d63fb0307"
    sha256 cellar: :any,                 x86_64_linux:      "7f1254bb9403016332b0e2a8d9bf90048ca4c5f957f3e90391d9e00297c61c27"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
