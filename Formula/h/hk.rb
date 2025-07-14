class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "669ee54ef177aaba5a17a03ed98e1340670a91af0f1a89bbe8b2aa5d907e49e0"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9745f6ead4d2f546cb9997645625fbbcd1fb867d1e7fe17323af9861eae99d8"
    sha256 cellar: :any,                 arm64_sonoma:  "263973a26f1a7652e99c75011b5df653c38e3e49cc1bd052704bfebbd9f2b438"
    sha256 cellar: :any,                 arm64_ventura: "7a9fac9340a18e31945e6e6b5a54143b8c26395651627db4da89f7a296588c63"
    sha256 cellar: :any,                 sonoma:        "9df776150a8c5eaeb11d810597503c4aa46c1e2e078c16b2f077f29fdacb2d09"
    sha256 cellar: :any,                 ventura:       "eb6304f7cb04a55b3540a6b8af5101d1e2369540cb5cce4f8a2ac845dcf582ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb00605e1b7ca67b61e4457bffe94271b91e708eda5132e809fde9556399cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdad490dc50e31fb26156e00ead00873944491c26b851846ce68b5571555b181"
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
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
