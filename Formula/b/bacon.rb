class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.20.1.tar.gz"
  sha256 "cdcaa493d5cf68a4fdd6f17c588b1ea77177bc96e493818665abffbcf00a3900"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3141c64bfce0af35ef1c20ce605f169970e54d60713a93709e2dae4df3ef6c36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38d8bb7de9dec1f268b8485eca1c0fe03941fa0155e19cad6d960d5dc4aadf13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222b49b3e01f3be7601ee7a637e0a1f9d1ff340abc2b2172c0ed061615d3463c"
    sha256 cellar: :any_skip_relocation, sonoma:        "937bc1798be34d8f1f8cf75d5000e4d40496ad1f57ee5fc7590a43b4587debca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce74a45ca5114d23b2c34b09e83813f3fb34bce3e410297191408fb3a00aa75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b55fbc864fbfa26434c7981b82cf7f0077020403fadc76993f89282e9dfef0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "alsa-lib"
  end

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
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
