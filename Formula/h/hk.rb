class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.0.0",
      revision: "f4ad840548897eaffedc55a28ff262167dda96cf"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6007b3e17a0f133e7a78dde3d9bc2146802a6c2b164677601ae5be30af5005ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7834ca5da1ef9c6362f4261edc85b2fe5b3052a6e4c3b3572e82b07ba49f1871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e54c784a0dee80a88ba1e3c139d18420b97db67e103d8be712cde39f17e82215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e3154ff18d779e778b8e471cb9f8d6cc180cb7c6fe7a8d909d92edd194f3ff9d"
    sha256 cellar: :any,                 arm64_linux:       "b9a546d8498a43fb1bab8eb17f87910e5d0ed49841fbe593c30fa5c707503e21"
    sha256 cellar: :any,                 x86_64_linux:      "cfbc9f4512eaf5f5c903dd336693be9f6d4a384baa40fca3f62af488407a5bc6"
  end

  depends_on "pkl" => :build
  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    # `mise run pkl:gen` - https://github.com/jdx/hk/blob/main/mise-tasks/pkl/gen
    system "python3", "scripts/gen_builtins.py"
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

    system "cargo", "init", "homebrew", "--name=brew"

    cd "homebrew" do
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"

      system "git", "add", "--all"
      system "git", "commit", "-m", "Initial commit"

      output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
      assert_match "cargo-clippy", output
    end
  end
end
