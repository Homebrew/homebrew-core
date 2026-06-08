class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.11.tar.gz"
  sha256 "bf67d37526a4c7c4381b37780d0839dd71545c058eb3cb1a15ea051f973f67eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b259d3fd8c29722056744d1bd2280a054ab54c9492fb8c0edc82f3e087d37bf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f426727b781a993bdc710662c3fe8ee695dbe2f7770414b6a72d06527045422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "212d55b4a2a5a426e24d064c5ffae91d93a7614136439c1c07af74d5c979cbfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "486cb1799c6423f38167296f779183105885169398197238e36eaed809c5d93f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ec04ddd3a7740964b18f74445a3fcba93edbd3c9817dbecfa7943be60553a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87429f7bf1876a473e17a7ff0b5f52ef690e5c495741b4bd0b96d5d412d1a9df"
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
