class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.38.0",
      revision: "79723d03eaf2da70433c19b2425aaf3197cbcfc2"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b55a6dc6d8abfdc893798930aff0d43971d693ad860f5969ae2887465019f0be"
    sha256 cellar: :any,                 arm64_sequoia: "67054f78db96676bdf42a2337fe3b223a1511fcf376f8bd7841ab83294a85169"
    sha256 cellar: :any,                 arm64_sonoma:  "0e47fb870f557771ec3caa1e6ca00a33bb2f613d6d88ca948e02bebad4d0d7c4"
    sha256 cellar: :any,                 sonoma:        "798bede591a9846f9c30693279348146d7423540428e1d13e45b0e36fdec8e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80be20a7d43c7ed47f4ecefa5f4c80abc68f91e4fe3abfcfa6c2df6a4692720c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b8f5dce2e44fb60d3e3a2b6a4cc4ea43d9bd71a6482c1dbfb7078bf18d712ba"
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
