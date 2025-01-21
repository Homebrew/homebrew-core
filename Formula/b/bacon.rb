class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "b5db72bf1be28ac67c2df5ed251fa806091a46af5ebab176a6f30d9566ca25c1"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e592bff39faeee6b9026cae7e205847ead5a77730ce90f1526aec8ec6752bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e6ca3122960478090e63aa1144a7fa67ba15b258fe9c1abe3c408cbed404d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "809a198503797362a5b36d2fee6c4937f564ec0578589d71ef9041dfac043e4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4421a8dc7669b8dac4dffcf0f9aab1183f0e0b57844ab2b2fe5d0f1565cc59"
    sha256 cellar: :any_skip_relocation, ventura:       "4982bc16fcf32011be2524853323a58dea3fd3641f2414d196ca06c4a66233ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5960372397f9a92f759c7c5379df2c6d81f9c5718a95b4e72ff66f3e98a3e350"
  end

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
