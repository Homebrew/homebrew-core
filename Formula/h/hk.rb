class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.32.0",
      revision: "22cdebf1c3d3ad1fa868ec4cd6f863982368bef0"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f1539eefff4466f52ab468c5f4378e98cbad82f5e84960cb0ea0b39214dc4b7"
    sha256 cellar: :any,                 arm64_sequoia: "7153e82e3b6561ffd52e7977f4f5ef24d8ea8a0735c4e8ecd2a949776a831e86"
    sha256 cellar: :any,                 arm64_sonoma:  "a7a2b21a7bc4e8ce60445ae7d4543ca2909fea12e9d838da211f25c1ff00e45c"
    sha256 cellar: :any,                 sonoma:        "d84f756e9183b6277d25b45fab08a08f6038ba1855f23323a02ebe073dd1be96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0184301fb7e3f8511699eb25ff15bd7276335ef146cfb3f5b6b632774c28a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230ccab19ead7fda742d074595e9dbe4a01fe1ee76dbc7a4e03e78e99dda1f3b"
  end

  depends_on "mise" => :build
  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

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
