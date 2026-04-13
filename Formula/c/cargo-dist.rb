class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "6ec097f0916343c7a481d44c18b898c2eb41f00f0c04e58da74248fd3647b16f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6ea59f0de4192fdb792c9bc2594b3d7d843a9193e275378dc604b94947ac871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7bd6380f8e6032202eb508e0c30e5759716a8a0546cca9c1151bfdb5de2fb75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ce320138d845e5581590b4656a7e4a049715af7ed275074a6d39ec85c6105a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d535ce54dffaf036da7202a1e2479f3da4e4efca5e3b1fc80ff04a294136658"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a0dfa3e2449b06adce08ec524e89c2516a3dbb0c6672a28baab15e4cbb121d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d3e314ea5e9e1d888c3b3d9e9e6963337b40ba40a4cbbcbc920570762396c9d"
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
