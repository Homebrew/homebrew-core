class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "cf7f3471883260f7cd56d1b2bcce713463082e64a830bb46489d7e94303b3ba0"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bec10b9beaf96bc4bbc6b868d369741c1291a12c18e97223af18203d8f6e0d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f284281c13953f8847250463e09c36129d26d505defa17d81d9c461ca2fae4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7500b10d06f6fcf4775966c117720a39005e12c48f37bb5ab5e7d903b38fb21e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9b34f95d12be979d536325391e843111973094a1a04e776395aa6a2336c3a99"
    sha256 cellar: :any_skip_relocation, ventura:       "5954ad20e803ff9d68ef08ae9e3b224e1d988f37561e5fa655b6dc4f00f9f756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e38d8e553f79c0e5da15984d4f9f2b4d55505fc610f711ea8d85c1e65c3c7f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f42d4795e429efca0f607b1acfe7c3ec544bad1ee8106e9d805e658b05bfb37"
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
