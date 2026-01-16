class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "6df36011ee90735ed11904fb6a58dfa92cae67ca4c0ca119cfcd0f1ff2ce27f4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b666ff95907f8fa5d4f06dee1e78681f03f8ac92f6b287e2d2c2c91917704c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8670b2b61eade3c9391eaf8a61acd49e76874eba2406ba1540dc8224bb2447ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db67f13f4d66c6b630d198b21622207b3ced38f64cef83a1ad9596cb4d2d5a9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "740dee8d90b3362fa82e488e840cdb866b108d967e63edc6e2d7f927b9b9f54e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041883a6e4e56303ec3d1839425bee7d2989ab5e07fac9ef64507bff93b89109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ceff3ac5681f47179303ad32c7f282db0ecb574759c33b5bcc9e229bdca506"
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
