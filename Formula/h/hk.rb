class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.36.0",
      revision: "51a60d96a30f3ee3f252eebc8b01bb744739d235"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2ce00cfd16c9eba147547e08f1a602566c507ec18fc78ade4e8cc9cd2ecba9e2"
    sha256 cellar: :any,                 arm64_sequoia: "ef8581c0a5e3575fe5b1fd88a2a1ba97287573003f630f4f1584c00f473d2316"
    sha256 cellar: :any,                 arm64_sonoma:  "2a38bf7fca0f199b510b0354c7d353a1107d488a555875badd9394f1692413ec"
    sha256 cellar: :any,                 sonoma:        "4a88da1138957d4e414de865e42cc32055d15c6091d1cc0bf705dba318228311"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b199f1610e2d7b7f3cd34cc8a9b9d8c9952dd7e0490d2797d9b51dd4b63d9710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c31e78d58abe8caf4d2cbaafee6b503b390386d846d821e830bcf68f387e7f"
  end

  depends_on "mise" => :build
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

    system "mise", "trust"
    system "mise", "run", "pkl:gen"
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
