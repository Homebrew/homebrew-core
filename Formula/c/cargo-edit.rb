class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "11a973bc77ef1562a599e8acc844bf763be4e9caf6e5a650239bc9c6d2077e5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "763cdcd9740bfc003f77a4001544d2382c7f29076c4f6f27ba3617fd6488df48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf9cdb02a17bf8057c62cec26e9d06e765f8a607c1e6a5ec22c7414d084d3dbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23e9636f546189449194584d254d124f4bad412218f3905bdaf2314e59d48465"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d3e85d2ad06e42df060290510ced395aac62a24bb7b86c0d2f2da0bb42ac3c"
    sha256 cellar: :any_skip_relocation, ventura:       "66641ae544ca6b5b42a00e1248ae64bfaf7453354a3cdb2d81eb2c7b724098a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "119bd0a56a3cc5fe61eec7ae8b6bfc09ed4be06d8222c231c61e92d5b5de7178"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
