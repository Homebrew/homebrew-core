class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.56.0",
      revision: "bad550709d9ce2e6f43a8d25880e1c7d6397f13f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e6fcc708db53f239b9e7cea2f6c378f8d16285b01c214810b4aa3d846bc9d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17cdba05dfca31db7061d755b487e832cc8ec6c34f325824ac475914cb6cd8e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b377865c1ba75c06570a0289df4a3ffc2d354d3d6579073dab6a1c8786af3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e6f54038e6f863a3eca2a52f6e35ebc7d5887e71c5831f164c3f29bf012fdc2"
    sha256 cellar: :any,                 arm64_linux:   "c3df0fb1f65d905f238a53d954d23ac4714252a9115c231c5fd09cf72d0cae2a"
    sha256 cellar: :any,                 x86_64_linux:  "b5a740a5ff30817a5bff7f1dbec13167dbc4941893462194d14ebf4865d9927a"
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
