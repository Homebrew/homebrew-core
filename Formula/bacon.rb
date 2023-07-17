class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "c0081bfe33064707e464bdeb7d569d818d90614adcb8f662e0acc8c5e1e0ccf3"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93a93ae0beecbe5defc577d1932dffa9072eb518eb01e67082cc65e425d212b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb6be4f79d16e653e30d4385c613b2800645e3d4f237a2e3c5908fc4bf6cb04b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9270160a86b94d2ace308521fb7adae424c0b918f8e6a43ebb882bab82a587f3"
    sha256 cellar: :any_skip_relocation, ventura:        "06c4373dde68072da7cd97233ba0d3c0c7e7f5a31d51bf73fcf3d0ab5fed1a65"
    sha256 cellar: :any_skip_relocation, monterey:       "f08c4c76b3b45b2c00adbb9d3735f4ea16313c9333e69f5a9af95e9a6451408a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff1c56a4fd52dc3a07fc8cbd3ee97e5e191f2c16c95cef6585595333b86202c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda0840f6cc4e76c45838b68dca9d1ef97362b48d20350c4abe03f681f0186f6"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
