class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.24.1",
      revision: "69e9188e98f5343179338e41186d506c90cace4b"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c4b0fcd184598f63da2ef3c4fb5688b0c34a3c3909d6b98cd4a68a2d3d528ca"
    sha256 cellar: :any,                 arm64_sequoia: "0ace1779159b564b324814327300f125f65c12a0f7eb25ebfdc19c7c7e42d0d4"
    sha256 cellar: :any,                 arm64_sonoma:  "82dd991653574c478c129716312e501c0410d3b78a25f8cbd8803a5ecc6f2b1f"
    sha256 cellar: :any,                 sonoma:        "a94670f38546b1a71cb59cacfad4702f67cb7c8797fb539d281ed8611b8e9d5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6406091817052af36da24f938a1ffe1cc7f86a6ec837e8aaebe4c33ec1b8fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5af9f82d3f9d08ae7dd746e6ff5bcc7313f4f8646d906f006d0895c89934a92"
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
