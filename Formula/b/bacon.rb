class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "a7913eeab25f47aff651b7e09c46669e6d4b4a56af07ab6cac686fe867c72ddc"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd28de253e176bdbd42a1e77ccefabec3082177987065cbb7bd6da9c23b75c3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c2d7f5b9a7546475cebdf3e8074c6fd60ad6b99adfbac7ec8186db825b4dcdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9490a35dc37d527f4f4a17a8fadc5a976ff26d7c11fb9047b3d1c8de3a9b3e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5991ba0f11d6c7c78d1fb20b27f5b3edc5f69d07b65b30e9f9c09d78a5f83a48"
    sha256 cellar: :any_skip_relocation, ventura:        "bf1c2311f102ba97b2696f14ea460600a03f2c9c0bf4d61b9aaf9c1446ff0e02"
    sha256 cellar: :any_skip_relocation, monterey:       "11a369f5b96ac470c91627d26e05fdda3c13392a9825c078075daabb9af63bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4452ea03b943be41c145d45d4219e67c88dc5b2c3c32ebde80e593ef372bf00a"
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
