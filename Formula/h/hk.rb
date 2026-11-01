class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.11.0",
      revision: "a0c22a90ac075f52c774cf8be8bf4e45d2b6a42a"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84a308807b65160ebcd464f2a2a619845b45557154d447a7de8a7a472af7f8c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1d162852674068b8e70fda65d2fad91a7c6390500762c21cecc22fabaabd029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b103e7f913e864f382165b50773be889ff07c03a10b1d741a308bde94a858623"
    sha256 cellar: :any,                 arm64_linux:       "043ea46af896ee46e538ef05ccce7ba169db9636d6517a76a3aece0b0f6ae51d"
    sha256 cellar: :any,                 x86_64_linux:      "8296d1931d22f65a772e61ba695c987c9f297054d14ca6158d415eb0b65c9407"
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
