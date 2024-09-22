class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c81a73fb1ef4ffef722835baf473beed9868ce2c58ad98a27596f2cbabbfcba3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "624d19751efd16bd952196ddc9a3cb3a8a73ea484f357ce501ea0cd8495ee803"
    sha256 cellar: :any,                 arm64_sonoma:   "5235c556554c2eb6def794df2e685aef958a2fc8a1065d3633a14f1e8b15f167"
    sha256 cellar: :any,                 arm64_ventura:  "6107b6be4adadbcebb57c48a1e2d0a9db7ee59c3c88ffff9a26291464015ec86"
    sha256 cellar: :any,                 arm64_monterey: "27a9d9bd285690b75e28929ad7fcbc4c823d1d4edafce07472795401c5db95bf"
    sha256 cellar: :any,                 arm64_big_sur:  "96f7883d97ab6de68eaf0cda9deecf920754bf438c21ab920da63def1379d786"
    sha256 cellar: :any,                 sonoma:         "0285b7a2772bc5f346319ae2bfb68d685a0e47bb5b08856f70ce757eb61edea0"
    sha256 cellar: :any,                 ventura:        "ce20a66b7219a80617ad20042284afd4eaa8608f90084ca854701fb31e68c7e7"
    sha256 cellar: :any,                 monterey:       "78be6fc5df8d7ae8d3926a0bb1497ac26db866acb84ddb0974dfb73632fe6018"
    sha256 cellar: :any,                 big_sur:        "1be9c417a263a035c124020a65786c495b2219d664d4bd18d0a7b0d850c37a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79df633b377c8c2fd2ba9f73ee41ca825f7158688d8a378110f56625c712775d"
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
