class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "4507f5fd73524589a5c357d33928983c891c6649255c9f367930720fb5a60f4c"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24be287507fd43b49d56c437fe669608af3a792da822bc1a24c70d125c9f90e6"
    sha256 cellar: :any,                 arm64_sonoma:  "238741f48438a13aa9875289dc70f17594a4cc6a8605e548cad286430df73690"
    sha256 cellar: :any,                 arm64_ventura: "e4eb4454c1b4462ffcccc3fcb2d5d68b04e0d041ff884ee6d59d3fa8dae7d75a"
    sha256 cellar: :any,                 sonoma:        "e57b21c828fe7c051b198389ff719c9df47c6fd802f017d00744f84e62ebd0cb"
    sha256 cellar: :any,                 ventura:       "c99a9a0b84e0c19f545a4ab087f93a6ff18a82fdab3d518497534212a013fc85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb9c053e92db170c209a75f5abc8d6a28878ef37415e6cc6d42853155a3e29b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09dde63312016b65fee6b1c787ff9e3d7a05987a54f90131018a96d4fb650cb6"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "package://github.com/jdx/hk/releases/download/v#{version}/hk@#{version}#/Config.pkl"
      import "package://github.com/jdx/hk/releases/download/v#{version}/hk@#{version}#/builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
