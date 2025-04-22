class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "18d5ae6f2c1f85d0604e764eb1d1802c82c5657176bf54388ee7d65e2ee904c4"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d1cef5fc862e8c26115a6cab56da98de553dd37ad01e10aee076d24b1ebabce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9794da55825255345537b9905e1c9196dd45e2b9f90e0bb55aa8205e19563028"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ef55a63a6eb49f771f8ee9b48b7076e0c178d3776635482bea3add593a9c438"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bd2f417d96e67a653772ab833a303f75bef2f92a0bd8fd2b93912ea5728604e"
    sha256 cellar: :any_skip_relocation, ventura:       "d64bc681a19dfd38da4901612a456c9995d9eabecce5da192709c6dda77258ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a97a99f5f19e6d1481e2aa04a4e2991bfae5e532f5d8b9b7a50999606af7fbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2453871d1d71575e462f91dfb9033db055055bf9ab3653ca5accf171da3d3a7"
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
