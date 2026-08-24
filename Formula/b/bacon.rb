class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "6657e968d189dd5c165dd6c9b97f667140baea87d126d765a2d5f1e97b007b26"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a922e2c4abb065c3d9bb6aee311d7ae918b2210c6618894166b8f04e420376c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e284f1aead5c76b7153595ef5f8cb77f83a9b1d1bdc84945c6f683bfe0393e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4289a136184f5fe0ec034a0ffa815a1af735892813b5611e0c89cbc4f887f19e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8723f7420ed15ae42e84a8db06c73bb4966b2353ed1e39e6e44181fea3fb29d"
    sha256 cellar: :any,                 arm64_linux:   "411f3bfbf1dde219e349ee6ce981611388e3853ab355e275e2db6b9cae8273d9"
    sha256 cellar: :any,                 x86_64_linux:  "cd2f9ac5770d9d017d36f76803c3d69339bd21500e54526cc83a424d7ea34357"
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
