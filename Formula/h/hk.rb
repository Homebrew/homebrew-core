class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.53.0",
      revision: "524fecd9b0cbe24faae47ef2080b19debd35b61f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9051841ec0973774012b3a5c0c9acedbe5901760c4209016557e565da9e65d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3791baf536af40335a4b1e28d04c14d2953e5a4104f3583e9a1575f8286de96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec9edcb625bedcc65eeafee993a9a8d17a9c6ae6787837a13b5244bf6c0bb40"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c048eb5ea5faf3e4fad795750c4773c449b1ac26db26900ac7d1a72c5753eb"
    sha256 cellar: :any,                 arm64_linux:   "67ffb29b9cdf57f952510f16b57d99878f0425e7329c580ef7e9a07fa5065c25"
    sha256 cellar: :any,                 x86_64_linux:  "1e1cc6685d397135a48c447ef1ad1ccca9d00cd18d13852ccad5fa493044f7ad"
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
