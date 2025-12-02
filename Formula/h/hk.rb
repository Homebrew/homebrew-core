class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.25.0",
      revision: "1a398e12fb99b8b7099da58fe6c0428228e1b2e0"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccd526cc6cf0a744ec8482eade546eb4ba05c9344c86250127273fe945e0f430"
    sha256 cellar: :any,                 arm64_sequoia: "12440ffdb799083bf6c0527481d2fc6833fd6f723919f93250b8d9dea54a02cc"
    sha256 cellar: :any,                 arm64_sonoma:  "13aee25b254a01f4dda2bf869b4275bfd62a912dec336960648963b887bfe3be"
    sha256 cellar: :any,                 sonoma:        "ac58bc1b08fa4f57011f414c5717663f50fc072888cf8b8f886aa6d16180f197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d5479276c363d0628f12b582037de8aa7cc2610b6bce6e5ac1feffd4ede622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02882172768346d5bc70bb959033ff1f2e2a3ca974ff60c499c2c6a8f5587158"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
