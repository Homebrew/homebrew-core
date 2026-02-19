class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.30.4.tar.gz"
  sha256 "298760bc156d90ffb9d11a5e4e99afbc1aacbfeffb73c257a6459fe8e48e1abb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5cd3d3602048df20202ddd6d94a7e67a6128130b5cfad22786cf49c5e1fd7b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c062c62fd61fd2371fb546611ec367a2dce53a97b0535e91025a85d1d30d0e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6724640184e07db5b613db025960031807e3323e8081a9b1351a01346502cada"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eeec72dd0418f1d79fea3a4c7a129e21995adf70f3ce5a78125902390196c93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7511c59d9f5d1ecb1c1c97102bd63c4e9ae54736856f4bfe308d41d066e83a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec58f8c7c8e67521bd60b5a3bf5c13809595521cf6335eeedc8ac232245dfff"
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
