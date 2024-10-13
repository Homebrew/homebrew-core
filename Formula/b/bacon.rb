class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ff2460da9f527f48c899fbf40fb7e2645dc3eb28e04677490d7fbab2bdaf8fea"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63115e77fe6bb868db544cc5889c2b80c5436cf92d905474c0ce602969b75bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "238fcce605b488082cb8391204869a8f7fb9036e51be13f16ddbdf6df0d2db15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ac5336e8676277c395ec9b95407ae30d88c7f1378e8acdc0e98d6a2fe72f899"
    sha256 cellar: :any_skip_relocation, sonoma:        "321d525118678bbffc6e3ca080b4f4f817da49a2fcc62ed0b69fd8ff2ba89fa4"
    sha256 cellar: :any_skip_relocation, ventura:       "aea0dd43bff127e5bed0686b3aa2c653af58635fe4048224b7745106d2eef7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1a47e5ca5913cffc3b4abf00bd95917a72df26aad789c56d9c3938bfb06b07"
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
