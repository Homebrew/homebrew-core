class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.56.1",
      revision: "fdbb35c1cb9d1487e8350a0888877c0d74d4b611"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ebd8140f4f5ea52d0285614931cef0a7cbb71a7bc030e1c9eeeabd3102b7181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539baeaeb23ecda168a7ae987fa6ac8012bcee248c4bbb149689c16ff8edc9d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d7a94499741a138d510610f8098286c04fb53d7ecc713dc214d96209e56100"
    sha256 cellar: :any_skip_relocation, sonoma:        "60786bf44c2aecd99540389f45efad3e41f8d63ff039190f83b6a626ca68d998"
    sha256 cellar: :any,                 arm64_linux:   "3c67fa0371ce30ea580ec755ddd007e458087057a2c2963852bb9482f3feb37f"
    sha256 cellar: :any,                 x86_64_linux:  "05609e491e58b51caece2a3bcbcb77369f8fc4db2ada89e43ca8f0a5a1fb854a"
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
