class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.34.1.tar.gz"
  sha256 "4196415ec524bc2862febfeee016204168116d886392cb1781d865a57bef753f"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0c013d3a97c1df35b46644a7ae17ee094b98be6d787df435ea68f5a24cf2baf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8199fdb5199523423503b985ed01dfc24d31cb031cf9c177d67aa623c51a29b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4015a1563b953b2f73b96339795a77740f63a2cb27fa5daa6aed348daf92e09c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4398e179fed5b661fd95c147aa0236a05177837e8ce501445e3f49de538563eb"
    sha256 cellar: :any_skip_relocation, ventura:        "5fdf4824a3fd10f5c91cceb137c03e598cb1ab3f43b83d6d3f742eaba330a9a7"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff24b7d21241d7f54600603ce6961710329ab02db28c52934e9a53e70ea8ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11366f27d105cc360df7576d6ddce99c2aa8399913c9ea635dbdda3328b2a424"
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
