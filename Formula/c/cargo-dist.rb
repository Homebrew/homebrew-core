class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "ef9b7cd1eba124fce752d1bd8414bfa123e06074d370066cb2621992c67d0af4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba42eaa1e5a3b845739624a819a46263e85a5bf7f85055380d1066a11f0c138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2d4878c888c7b3459858acde0c615c082e075e710fddd69fe9ef26ad1b147e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "968f7daeffb1d13273e3c787ee8168f288e336b4e76e7ac400e9c9ee4b7e3cf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e73ea41b52d557c939429b8ce4a46cc485857ea79c3365ed25452d0efc61246"
    sha256 cellar: :any_skip_relocation, ventura:       "2a539f976a6e3c321a4270276641e4dbba0897322f12a0cad104480e5a4697e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "511eebd1ea06491adf087514050e59eeb315465b5740df25ca0f1b24b3b73e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec7152a262e3edfce50cd61d60fc7d3d2b7105b4ef82c9aab41970738c08114e"
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
