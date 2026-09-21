class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://axodotdev.github.io/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "d715c088d9ad6401d7ccb45a9298469e08f44e20cd6d54f51d5a3ae756836e92"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "561e149ec75c641d0fa5d08752f51080344c2d6bde23af692bc7c62a3b59e821"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "999afe2b3f61b3cd7b4bf999f714ada1f96a3fabfb628b55862c55d887d1d859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "064d1241abcb43af413bfb4495a8147b35411ee3924d6e6dea20582dc3fd8c0e"
    sha256 cellar: :any,                 arm64_linux:       "f272bf14182768ada993cfddf8797b84b885251056a6190f769ecd55550bf3a3"
    sha256 cellar: :any,                 x86_64_linux:      "225c70fec9c10c68379fdb4a8aeac2c659d1ee4259935eae720659236399a631"
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
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
