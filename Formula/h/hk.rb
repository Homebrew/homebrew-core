class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.16.0",
      revision: "83f0e115882b56074ac1f7159116392c90b60970"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b125e3e6cc160230c7096b7f6fec80a0afb109494353967a74d016ef15300f7"
    sha256 cellar: :any,                 arm64_sequoia: "c3bce9c1389d7341ad8ade2e0ad4464a5dc41f853debe19a839d4f9f5cbcb914"
    sha256 cellar: :any,                 arm64_sonoma:  "aeee5428c53d8a6aa61bad26c25551d947f81c3fca35797c8af201a7350787d3"
    sha256 cellar: :any,                 sonoma:        "b4a7a4a6d5387ea3b05429f86622c7cb5bc7e72351d9d0d51f4f845c658ffac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd2a18207ca43e6efdd7d0752dc7cc7c0793315abaab7fd190ae3f9814c3cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f75a627f166137ea83c25efeaf3fd5b4bfe1150be95267e23a0f8d89bab7f3"
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
