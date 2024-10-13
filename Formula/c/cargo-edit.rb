class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c81a73fb1ef4ffef722835baf473beed9868ce2c58ad98a27596f2cbabbfcba3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81b766b66cad606757d51623de9528c9903655ebf033b27e937223a80c00efdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ae108fdc203e465e6848966d80c1a35bfa849d56b1c731ecbca7816e633561d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8001ffca5d9922aecdac84259f3a2eabcb8addc230a5bf025d6bb540696baf44"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f845361ee58b364b10f603baea77a293cead7b2100941511394a2c06c9cada"
    sha256 cellar: :any_skip_relocation, ventura:       "78769e2b803b68a887dcedf289236529880b2dae7b7b9eaf8d7a53bd7123d882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a7e551e57b7ec7b6e22015bc2d4971ee8c9ec21eca1784855dd019c3b863ef"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  # TODO: Add this method to `brew`.
  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate/"Cargo.toml").read)
    end
  end
end
