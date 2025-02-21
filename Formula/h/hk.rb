class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "753cb1173713a47eba7e90f9e43bfab120596cdd1c47ad306e3f7823460dd898"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12c2de93fe916fe931c09a33569a1d3d349d62e0caf4223e8034e9d1c033d52d"
    sha256 cellar: :any,                 arm64_sonoma:  "870670860d9834b3e4ec069e8f92f428072d6b497b5ca37092a8a30ef99abccd"
    sha256 cellar: :any,                 arm64_ventura: "b81bf1f3cab50d2aee75be1a16d78456b3eb232ef74d638c070a6e87dc42ead3"
    sha256 cellar: :any,                 sonoma:        "aae07a115cd4f5d4a47596c3fe62b2f3365713da190be3f51972547e71817867"
    sha256 cellar: :any,                 ventura:       "f2e57059a3e01e835250aa3fc42267df134d763fa65d54bba818763a0a97f75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd1b1efdcea77faf2435fb1dd8baf4b587bd3165eb10729a0470d3dd037f6b6b"
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

      linters {
          ["cargo-clippy"] {
              glob = new { "*.rs" }
              check = "cargo clippy -- -D warnings"
              fix = "cargo clippy --fix --allow-dirty"
          }
          ["cargo-fmt"] {
              glob = new { "*.rs" }
              check = "cargo fmt -- --check"
              fix = "cargo fmt"
          }
      }

      hooks {
          ["pre-commit"] {
              ["cargo-clippy"] = new Fix {}
              ["cargo-fmt"] = new Fix {}
          }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all -v 2>&1")
    assert_match(/cargo-fmt\s* ✓ done/, output)
  end
end
