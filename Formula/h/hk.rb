class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.50.0",
      revision: "e9cc0984a1a8d639519e76ab6e329effcce42144"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6f323f564b90b6c12a8505133824f794eb1ffe1071b297fc26be052dc91e76c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06b79fe68ee28e495b0cb3da569439721f765ee557fa64201a63f3e3c783993e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bb9464ee8a09e86651bd7ebef54b01099ce3d72e740d10e2d43e3584726a237"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5e76b1d261d001320771de07b4941c1e5e40f49d3c26cfd759403f03ec2bea7"
    sha256 cellar: :any,                 arm64_linux:   "1923690c7a16ab0fb3cac9536b8bf10ac64892cd8d74a41fce6d6ee3f9e564d3"
    sha256 cellar: :any,                 x86_64_linux:  "0c3fe470fef4198acecf5a49341f70c12b4c1fc866045e944b005a03ab3da6d6"
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
