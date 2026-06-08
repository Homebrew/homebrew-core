class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.46.0",
      revision: "4fbecf3a005598d952094b599f527618857465cd"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "691ddf6767c9eee454a5b13a63128fc89e89572a8979368e33ab9d3fba092a59"
    sha256 cellar: :any,                 arm64_sequoia: "a25d6d11db046fee04eb4f43e2d1c384e69dfa1b6f8352692ac568812f75da2f"
    sha256 cellar: :any,                 arm64_sonoma:  "8b968ae45be946e4dfc4396d6631c3ba26950aea706916dde46bb5a52320cdb1"
    sha256 cellar: :any,                 sonoma:        "1baafd3ca2c625517bceeef27e21c543f74c3e8e0ac499bd7c66fe89882a8c35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "117c6acf3a4965aae915f61765eb43d1a1cd062286c9c4d207e64259fdd99173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71a417bf2e8e8a8ebb0be559da72ded60e4de2821df11a706bdd70dae86cad13"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
