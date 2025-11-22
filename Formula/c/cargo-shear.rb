class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "191571d52a5bd2107ac83b6119981309ffef825c0b4c6cddb7ff4199f4647ff0"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfa021e566641d72253c5380130b928c0262b90f71bcaa91bb7404b84b828d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50d8035d1458a3ecba916ba0624b1833c3a6f3069a603b4876fe79f968d8078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2edce79b728eef73026a58697a7352def358c8e0968693f2549f7afe8fa38126"
    sha256 cellar: :any_skip_relocation, sonoma:        "76d9dbaf60c5389f24247e1ec66b64e7a6afbd3b1695802897662a9848fc79a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13e07c1e10510a44fc66ea2820e8e02f6282f3a0a16e32211c614b587000d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a3c2ddaf2250c0311cd38eaed03b8cdef9da2ccef659e8d8dead7aab23f33c"
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
