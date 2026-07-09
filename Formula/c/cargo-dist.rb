class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://axodotdev.github.io/cargo-dist/"
  url "https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "e248d3ab9cc6889494bf84879edbcc91cdd5783857c28c06c3f310d351f6fee5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9401724938bd5512130da6cf035d9dbc1159909e0a0c7872451cd3a9465fbca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a091968e10e4121fb767a523e6118992e4dacff1064c42d4273025f24dd3171d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6215878416dc1bc4d857f1b99272e16fadec6e35da426b676ac12c1d85fe2b27"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eef0b330f1333ec8396b1ace84b3ea1c9bf157c9045403fcde78409d2231d22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a712b4f417c131c6b1f765b79dad18479f3e7b36d694ef09f2ca021cc1c4085f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2fbd9fa55f545a1ba6f50edafd9966545c7bf04032eed8e616fdc67caeff42a"
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
