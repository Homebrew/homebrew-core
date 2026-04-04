class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.7.0.tar.gz"
  sha256 "155373f4eafa21cf7b4d02b9463b2ed105ca42b65983d426ebf417457f0ce085"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7bc4f841a00fa9206e5c5fdfd366693f8e1d4819f29d5f9da9d1b73a4d2387e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd31aaf74381b34128e92c99d22c6ebc9243a0444d2456f4ad0c9a4ce85083b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb98b70b1a4a2c9e3cda2efabcb093508040847983c7cadb279dd9666022692"
    sha256 cellar: :any_skip_relocation, sonoma:        "51be718a6d750fe0ba8c0b5dd9ed20110829649d5621a77ef7caa05dac4b5e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f819c07dc34205322f263d4f82dc895740233d8a12dbcb1621a29e695f43d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b20feea761aac3a22527ff446b6421387d6bd78d15deec9c226810cc9bd3e15"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
