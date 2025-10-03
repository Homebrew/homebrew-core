class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "2136e7604bf92b209c1363393142e5bb369bbe06a4f75c7d6cbe16d3437ad9a0"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba8a2a6e1b03ccd67a90231a3c86b9b1d49756f9074a6bd9ca03851fc576064b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "084aad9dc9734030c27384df6c60e37d295565fc73eab14e0e3557e80c6958ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb0afed3b3a5bf280c88e7432388eae7ead7d10d0748624dd22a871bf568c556"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60ec6b5ad1144e8c8be95e184c87e60d43f282ba2bddcab69cdf64c564db0492"
    sha256 cellar: :any_skip_relocation, sonoma:        "8152871bdd5dd7c017d02e9d26e417eecef5259df43febfa316487ea34d674ea"
    sha256 cellar: :any_skip_relocation, ventura:       "48a4b161e25f172b77f4cc45033f0e0b6adf18f4b9d69125bd50cfb56ce24188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd63dd30973ae2734ee46129576abc9e7fc0861cff960a8fd9401b7a7ccdb281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00e8d847cc37c617c60b7dacac817edf4247959a5c697315c98e074a3dfef86"
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
