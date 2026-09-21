class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.0.1",
      revision: "6e10696963aadd92b385c91ba193e7f6b79274a1"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d3244a977a945f19e9e4d5ee4da4412916953ef87706c6a94ebd8ba834a2077"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d9650d50013ab535299cae46719f99e87e92f0961716682dac9a2e35b0419ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8dd4b1490bbb72b81037bda09496eb4c43dc1f1601f9f2d638ad3bdcb46906c"
    sha256 cellar: :any,                 arm64_linux:       "80d8fc715ddd26bf2e7e66b7cd029dc244c982fee11b888fb2c29db3ba691036"
    sha256 cellar: :any,                 x86_64_linux:      "c9446102bdb9fffdd0a8c42f10937bf733e6f07130f6629b89053a2799aedc84"
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
