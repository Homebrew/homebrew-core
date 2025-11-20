class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "8c04414848f64a81a663b4c9200d4d04dc25b950e62db04767c0c0379ca76ebb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7911b2452d430d728e34f4b36ae28eab3a0d222811a6ef55dd19bf3da8398927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e10f25f117ceb9bc34214fd167ce5056ef191aada22b3e0492966e426c1fe6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa6f9c4bf28f10050274ccee18a1c42d68ce59db03f1338eb680269dcf70376"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4adf978a277afc38c52283fb33ee13b1ff60bde34978267f6691d09d1caff46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67c60c60c20c1ce83fd95843b87a0f58347c6fc117258e1f1642536d3b257429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7fd1a2dbe58f01b42709e86ae23ae97f704c907d413584f1d5c414f76410797"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  conflicts_with "nmh", because: "both install `dist` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-dist")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/dist --version")

    system "cargo", "new", "--bin", "test_project"
    cd "test_project" do
      output = shell_output("#{bin}/dist init 2>&1", 255)
      assert_match "added [profile.dist] to your workspace Cargo.toml", output

      output = shell_output("#{bin}/dist plan 2>&1", 255)
      assert_match "You specified --artifacts, disabling host mode, but specified no targets to build", output
    end
  end
end
