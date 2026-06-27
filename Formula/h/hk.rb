class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.48.0",
      revision: "0b221a3e11b48aff266eee14b4b37abb7f0bb4a0"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d5317f665b9ad5c561d9654432df9dd944010e69150caa5fe3529563101e04c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b22cbd0f9db4dae9090c9117282a7b55a26cde52f5f591164a0b2ea00fd7be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "068785acf7dedda2ec1131c8856cd19770b4f89275b048dd4d6a5716d8f91fda"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef11c0bdcc69cf9646764656815e699dfe2ae5e4769276073476726c7e36d3f"
    sha256 cellar: :any,                 arm64_linux:   "b1ee804ab869c56d0f4037b6450c62fe8f5c5694f7665f38c310a107ff3aeaf7"
    sha256 cellar: :any,                 x86_64_linux:  "f67ece31bb75a8be1a4ff297665dbb18a429d1e61efad3b31e40ac3ca4f7c148"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
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
