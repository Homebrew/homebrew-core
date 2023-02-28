class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.22.2.tar.gz"
  sha256 "182effd1ebe2ca83fc39367d0777b26f76fc2e6b95de2414249e981d8727e035"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4510b8f4ee8598416583c7797c525f4403bdd8e68bee62765725e7f7355b8f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4c4a3c11118ac0bfb4f27f485b6e7c6efb77b08c2f6999ad41946fc78efd025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586394b97a8c8985859c2420c30cb8eea1de9e0ea2381ed3eea567359ffe8f5e"
    sha256 cellar: :any_skip_relocation, ventura:        "22c908fb142c151ed46d21a2ce5f7f73e36349c2dbcb9781d036e703cbc9959d"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab1c2aaab783c93421b654ee311c458a115464d2ebdc4a052e94af618f3e3a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0655d5dfb1aebc6ce3fc2e907fa1b2fd3f189d6170e45d6e5541b8ae0a9cc38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c40c9009710b3b49e35a4deeb92237e83926fba08abe4c0142ac21d75c55c132"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
