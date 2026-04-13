class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.42.0",
      revision: "0c83e093151cf569a1f1fff41ddb4741c9c88a80"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87ea1dc2c8b252b8dc463af71be5b1979ee0459d32225728b09a0939b157be41"
    sha256 cellar: :any,                 arm64_sequoia: "15f8354acb76e2e9693b3a17b658886a60049cdd271818e1241609e32e2259d8"
    sha256 cellar: :any,                 arm64_sonoma:  "3244b42f26c42328a7a153cb60f2bcb580991216bc8205e0e140c0904dcc9fc7"
    sha256 cellar: :any,                 sonoma:        "9914a1878962f46d6753eb90288154964b8f1af91db659c19880ebcd4caa26c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36a0cea426d7a657b90788b6e1d2d047881d103a4e1aca751806465c449bea3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9adfe0572faa9d5d975b99ae36d7940bba7a71e4ad224684467f1ca5470d3631"
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
    ENV["OPENSSL_NO_VENDOR"] = "1"

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

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
