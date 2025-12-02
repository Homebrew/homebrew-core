class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.8.tar.gz"
  sha256 "73bfbd80c0f54bffd8ebdfeb579ba8bd0ba4be9fdad06ed0f8dc99d3911f4774"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a52dfe8b3c4d58b217875c74573d3c15abe5b43c9b1e317f12242d377eefeddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61e8bcda5da3db706ab96d1341838df44ae62c525d4c077449c77e4dceb7309d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fc9e0aa19f1bbc6d1bba2ca2d1d02d557f2f84c000b400ae2ddd160820b7772"
    sha256 cellar: :any_skip_relocation, sonoma:        "4968c1767c3952c1f1683e8425647f8e017c776c58bddde39b1f853cdd7131f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6f332d347e376a3850344410ee04367ef5eba241cc642daa016a1aa545a4d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217c786dc4fb72e883df140018317ac746447c4830b3aa6678556470395106ff"
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
