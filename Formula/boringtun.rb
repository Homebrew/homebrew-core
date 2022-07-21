class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/refs/tags/boringtun-0.5.2.tar.gz"
  sha256 "660f69e20b1980b8e75dc0373dfe137f58fb02b105d3b9d03f35e1ce299d61b3"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c04b158add7733fb8edfe4bfb56a0098ded750282720639dbe0d62e4f9b98a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b79542bd106b76ca6954733164e7ffee30506d4c43b343edfe1b368d681dc4a8"
    sha256 cellar: :any_skip_relocation, monterey:       "b21b6bdc08718e301d7a412c522f4fe0ed580b0b233e541c669639705fef45fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c3c6a06623640f07e36039db7c7e87d39b413d034cbf6541ba80b25caece6c7"
    sha256 cellar: :any_skip_relocation, catalina:       "fa05784c502a336f8bbbe232ba7c4b480f27861edc5878085a1e259403b5e513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e64e3b6ae780ce082c0a1727553de7c18fc16446bf4397b911b302d1aa8d17"
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
