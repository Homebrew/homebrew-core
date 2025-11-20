class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.22.0",
      revision: "a32e8d5085cbc7a7914898ae156f5fceb99d809e"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "685f939b94e7b56180579c06443dfb3cb9987cfd0acd0e2343da55ecf235400b"
    sha256 cellar: :any,                 arm64_sequoia: "4a6ad85fcde5b9214a201707c5241f2af37299a931bcb7858e5519ff22014fa8"
    sha256 cellar: :any,                 arm64_sonoma:  "7839d12d72cc31117da0b2135ffbbae6cb9f4c4082781be5e58c94c51919cb55"
    sha256 cellar: :any,                 sonoma:        "95bcbddbc8ac2bfc252a3646f89571fad797706dccf403b107fda39af0b91285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5502be25c913d030857061abc951f56e892bb44b4579f39a71ddd050e1633575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940b353c06e9a3d4ae9d27baa5d49201101e27f43f9c441254c6434ce072e79d"
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
