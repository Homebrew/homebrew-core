class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.16.1.tar.gz"
  sha256 "8e09aef97b0c299eefd23f019ad615559887f4ae3d54bd6affdd33a503a04fcf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "62a4e06a12a1e1c2c9e02cee103d56486c375844b789fdf21c15384ca7d3d664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d71bac91a624fe32580277526e4b3933a17b95aefc1d67c70536a49ba2f3d44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd9f9a0803d3e464c3c5de2e401663582ae89ca6f3743bc21736543a1ad5b406"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18574e808f2260c1505df4790288e92365dbbee938162ef087ed7675867b1294"
    sha256 cellar: :any_skip_relocation, sonoma:         "281aa4d1b1ed51cef2934f67c3cd5b5aab6e11ae6b5a7e22af981bf9f9d6ee68"
    sha256 cellar: :any_skip_relocation, ventura:        "29219dbfb6086b4c868cf4f9685f9244381d0b7db54cd6dffee90d4482776398"
    sha256 cellar: :any_skip_relocation, monterey:       "252326a58dd6bbc98ed75f15fc64695b8807925af3eadc8cb5cedfbc9035bb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1dd1818ae40ecfb041ce0116027d74bfd99a1fcd84d61996cf5def71f20cb3"
  end

  depends_on "pkg-config" => :build
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
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
