class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/refs/tags/boringtun-0.5.2.tar.gz"
  sha256 "660f69e20b1980b8e75dc0373dfe137f58fb02b105d3b9d03f35e1ce299d61b3"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63895d49881fb0e40ea40ddbb0414233a42d3311bc77f0193266752c7723ca4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57d1a55c819072fb79fd26e479fb874070f4c86f662c5b17b040a63637e21c2d"
    sha256 cellar: :any_skip_relocation, monterey:       "359ad2ce46b578bd55f2faa7dbd41a6202b3b39e4b40beb0de5c0782a7a8ed25"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c0545c856571a954f151aeb643ff1f77283165b1bc95a5bc762b44184a0716f"
    sha256 cellar: :any_skip_relocation, catalina:       "dd64f6c9bde4f8e668736dd9aff22912e99a393c868605ec98d19dcf6885f596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6bcd0a73c3fbc14c3d786c68952699637cc5bd502dd06de29468e27bdded4e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "boringtun-cli")
  end

  def caveats
    <<~EOS
      boringtun-cli requires root privileges so you will need to run `sudo boringtun-cli utun`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system "#{bin}/boringtun-cli", "--help"
    assert_match "boringtun #{version}", shell_output("#{bin}/boringtun-cli -V").chomp

    output = shell_output("#{bin}/boringtun-cli utun --log #{testpath}/boringtun.log 2>&1", 1)
    assert_predicate testpath/"boringtun.log", :exist?
    # requires `sudo` to start
    assert_match "BoringTun failed to start", output
  end
end
