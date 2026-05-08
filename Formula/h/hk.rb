class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.45.0",
      revision: "718ab674270457b41a5359e39db7d7b803ceb19c"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e546cafbd75d4e87f7f2b1d61aab0a2667b57666ba20e2d0e37109198fab40f1"
    sha256 cellar: :any,                 arm64_sequoia: "e13af24027c55ca154f6dafc1a72f6ba67ab995b2aba71ee85aa57285cbdf483"
    sha256 cellar: :any,                 arm64_sonoma:  "3018c2d18028ab249fc84d6004f0f2c7c08e7945e4b315acada5f0ca10344ef3"
    sha256 cellar: :any,                 sonoma:        "99f68560d697576854b707fd552a8acacc5339ede472befcf9e9b241ea1838d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e8a8ece64765c1dc7b05576d25975e9d3edb5466783d1a4ee698fca1d828fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f702add49ba829605fba7ab55610614fcdea01139f6b56c89c25fe1a602f322"
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
