class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "cf7f3471883260f7cd56d1b2bcce713463082e64a830bb46489d7e94303b3ba0"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "515a9749166058a8f05e3647422ec5c5110dc00b2d9581c600be120b7234073d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "981114c4a8d29bffcb6ad44cceaf616848de901305c1fef52def4c06592acd64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c993a1aa2fed25096b81bc3c77d265238c672913af8e442bc24eaa793a3d676a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7af01dffb194be336f2d974cf7766f6ecf0acd390a1e706585e772374fd05dd5"
    sha256 cellar: :any_skip_relocation, ventura:       "d0f652de80161387e3afde9cbfcbd9fe4b1a8d7648b457360050519eefb7eb65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df774e15ca034e27075f70c9be02b4c09cf23cb10c5f47968840efac514ef00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf9b44060ddaa5fc64916bb84b61e81e3c9da34e689034ee5e120219ac25421"
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
