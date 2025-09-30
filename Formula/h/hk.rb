class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.15.7",
      revision: "84ef80971f52064454822c540b3908123cec12eb"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71cddfe971c3aa7522218ab9fbca8064d5843a66d3cdaa2ff704a799d961d41f"
    sha256 cellar: :any,                 arm64_sequoia: "a7d5abf3ec6539f1d8664a2892e2ab7556099cb4d2723e6204fad2cf10c7c9ea"
    sha256 cellar: :any,                 arm64_sonoma:  "ada9d272aff0a51af1ffd7e1193405e0d4df75917965d55d383ffe1952ec7283"
    sha256 cellar: :any,                 sonoma:        "2eda989b37749f264567b7fc26db581a8ed07b2a677058e1688962311c8b1e4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65528a2c298b804b545ea589c290019f54f1dbc81f12aa42f98cafb9d2d78051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60895dc03de75adecdc0117a447dffb3e34b9b889073afb2fc3c5892028a0826"
  end

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
