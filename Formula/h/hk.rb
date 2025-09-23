class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.15.5",
      revision: "be534005c5267ed33295fc10d331aae1d162a788"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb9c17184bcb4c0e00c651048b32018192db64e87c2b93541fad777930b0207d"
    sha256 cellar: :any,                 arm64_sequoia: "2f7a0878cc02048a5ab5402cf99d43154d6ad27c92d9b51d07b9c4a8a0dd8b49"
    sha256 cellar: :any,                 arm64_sonoma:  "ddbf525e34eefaf939a8c705b58a0dd71ba6711789c711e980926801947a5a9f"
    sha256 cellar: :any,                 sonoma:        "9da5ef25241cdf82417f5bf5bbf0bdcdb0051ca7664e57a7fd9336da222e4051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe0a7992cd9b58b8ed4f9f6325350843ff57a8a618244cab1c1dc0a2a58ee8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34e9725b9c9126441de4644fa7fd8e005f59c79096a59bde32336b2b7e911ad"
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
