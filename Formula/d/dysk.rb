class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "8da0e478a6027803043149c63c84abbb0dd4b3538372b8d854c2f8cab8215f41"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d699b1471bdd7d83632dfe5e9134ed0fd833cf6a59d441fca7d6035ac5a6fd33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6fb2d92aeabb4321b6071720549c02564296de051f178feb7abb3b8af4c2251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc31e41edcf08d074e93639a0122f30b41cef5f432a45635de428ab16f8b20a6"
    sha256 cellar: :any,                 arm64_linux:       "430e94ac51498457212ba83b7bfb8a149083cd804e603cee97be471a38aacc0e"
    sha256 cellar: :any,                 x86_64_linux:      "23cecadf61ee785b43c694996d1a489fcbceb7a990a0c220eb689ebe1311a7db"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # TODO: Upstream forgot to bump the version, remove in the next release
    # https://github.com/Canop/dysk/issues/124
    inreplace %w[Cargo.lock Cargo.toml cli/Cargo.toml], "3.7.1", version.to_s

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
