class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.41.0",
      revision: "98b1e4b1c16b18fb551ee1949b214baed39a9b8b"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6164f08e564be4bcf3a2512fb57ee1ac08bb540334d927bc044b83a11ddde94f"
    sha256 cellar: :any,                 arm64_sequoia: "369bc1abed45bde9082de1113909dad041e0b8ded30961de4360a478adc327a4"
    sha256 cellar: :any,                 arm64_sonoma:  "98931c9e4aa9559f5bb32a689781b7221834a7df4069a565a364834e6de76e09"
    sha256 cellar: :any,                 sonoma:        "9d134ad83c2958d3df969929c25a01cb4a704645972859c49db76e2fc41e89e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79bc041e39ecb1c5e23f792d53bdc7f1ff5624d8a073f6e6192f5732b340498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc91f75db8ffc37f1152b2438f369ac659ff1dc5348f259f13cc567c564131f7"
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

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
