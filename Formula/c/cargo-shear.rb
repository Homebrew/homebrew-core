class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "6e650a5863341db0a96b0f4ff71fefa3ad453aad711c1db7a805d1e3698e3b09"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4d86aa447bb05eb192e4c18796e0577bf6f87a1ebeca43bc7a549ebc96098b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17fce266de10715ff6937ddf8709cb3319336cc0aa8dd52cc4750b01fe04612f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec20f154946473bf861eed17daae385f53bfacc8d626ef62c6c9bcaf95abdbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5e9779c998965d2a98134dd1086c5d8355fc19c507530d21382739b9dead8c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ffeb59256a8f00221c4622bb2d52571d69c11b22cf3f55005257bec0d5f6bc"
    sha256 cellar: :any_skip_relocation, ventura:       "69bee06b525018ffe1ebb71140b061ebe491aec6fe443c75cd734d4bc1f05c3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16827a691c2ff09814ed23c4e0249f565bf03979fc573ffcd92685ae7744294b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3383bb0365cbd8cc6d0c3a3fe673ebe92e0ac5c0f5c92c5f8f6bf5484d891f9d"
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
