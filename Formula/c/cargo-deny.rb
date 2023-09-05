class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.2.tar.gz"
  sha256 "86152b1be86c9293b4bf0f80a1feedf6d9e045964c68de63d0407abf6aadcfc3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dbf1f9706dcc71088e39056621796572a98e476d279d231438dd172769cc359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30bf636696563b1effa2bb57c1335fde3a98341022dd59e13e940111d327b48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2921c93fe244d17cecce3a75006a445419e794491489be1222db07659c2029f6"
    sha256 cellar: :any_skip_relocation, ventura:        "eebfad6b17b610c3f2d807dfdabb6a713c633e3b9558688fa224285250783a31"
    sha256 cellar: :any_skip_relocation, monterey:       "cb0fb567f4352e58cb38250d4690718d0b8700ccbee0f0afe5aafb8548c4f624"
    sha256 cellar: :any_skip_relocation, big_sur:        "86f855d5545907f1bbc9881a438c18199c34444e5121551d1220c93fc33c95ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0d9bb63ad6dfd66916a527c6a2797ad6a7a429500c5e5d6c51ffea9b3bc05f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

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
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
