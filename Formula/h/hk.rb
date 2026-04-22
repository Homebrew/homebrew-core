class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.43.0",
      revision: "9462cdeccae1e517d4e9c547039565b60a06918e"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5280c9d1abffc58b87f94c6fe6df1960d8309fd7b4749a0799a46bf5c7d35569"
    sha256 cellar: :any,                 arm64_sequoia: "7528822c006cd7961844624c369cdc61cb4cd82d9afad39d3d8d581a998f80fc"
    sha256 cellar: :any,                 arm64_sonoma:  "ac63b96bed46023d35d04fa8f6b9a7ef7a70ef7cf930ad127b2b006f6aafef7e"
    sha256 cellar: :any,                 sonoma:        "14b26e07941604ab35e58deb01c2ea328ecad32203287d372e415698a680366a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "397c789642e1af4b3622a29b25239bc13617354559dd8bc1e0be5ea1ce89ffac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14aa75159fedf67029f8bdb8680a2841ad8dfce2d6ebfae1cfc6254c6144fe9f"
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
