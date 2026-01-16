class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.29.0",
      revision: "b397b72f3791a4edb8d6dff25fcbb4f00a7510db"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd8d3a3d49cc6e2e4b55d773178454ebdb6df815d995f5ee3257c156533b50e6"
    sha256 cellar: :any,                 arm64_sequoia: "1bfd758baf0c5ed6d1c23196ccef35bcec459b8e6ee6e5f4196ac4c58e4d3328"
    sha256 cellar: :any,                 arm64_sonoma:  "64acdfb131512278aee33873aabe1dec587f29efe1a450aa629af633575af60e"
    sha256 cellar: :any,                 sonoma:        "7699fac780ede047f14518be89ce6ee25ad06cd0cd53a013a91fb103444079ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1aa01dce24d72474fbff8a1387d27e280f5fed1b827169d22ecb483a580671c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "783478f5fe3b8ccd74cbaf8e8f67eeeb0b9a807070b6eed1fa911e1da5524eaf"
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
