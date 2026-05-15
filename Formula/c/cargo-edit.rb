class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.10.tar.gz"
  sha256 "f0c085d9e25bbfea568baf521a199290eb95bf162ddca586a7f87b2634d9a573"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0085678b01b83ae70e9af72018f959dbe3a2057c6d87322b151d38ac7884770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a235c03a28f85057c27255f3310011f9cb1ebb8e4f984e80b95253d7f196b79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32becd94b5fb088db38afb872ba48032f3daf1657c0a8b636ee8c732763da913"
    sha256 cellar: :any_skip_relocation, sonoma:        "603cb95b90ebdc503e3e0d7662e0d79d37a2f0c7e37441fe47e87a08677091b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca7137e71288b24c1006e8920f55c79558c79f8d0a8a46339ccc34f65dfb8b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee65c29d06c124652508bd85b00a288629dff7bfc3b7d67e00906f2cd40c18d"
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
