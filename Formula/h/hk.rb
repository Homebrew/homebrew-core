class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.12.0",
      revision: "131c2832ca8244f826d5632a4117fcc7483a984c"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6ce8679e4cf9661a4d0a71ccf532a643698ac31d48cce78a2435be449edac19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26383ac1337ee24bd4dafef8c431e701dc50b393e2d2edb12b82b773ef7fa489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e89b79401957cfbf25cd44ee0188c7b904efe80e3466cdf453cc1ae1421f90cc"
    sha256 cellar: :any,                 arm64_linux:       "c27369627ef2a9b1ae49cc5fafe2d5ebf1860ff563cb3d17c98950f3ff2d06cf"
    sha256 cellar: :any,                 x86_64_linux:      "bed8cf822b7e87fcfc0d4687ebf57eb683de70a176194b0c8dadf4140b61538c"
  end

  depends_on "pkl" => :build
  depends_on "rust" => [:build, :test]

  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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
