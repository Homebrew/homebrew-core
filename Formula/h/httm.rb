class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.45.1.tar.gz"
  sha256 "df99d4614796c20a355445b5cca2e4308e31a331a99df2620f3470ef30973481"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b37a15ef945631b9a659b74dbf1651776ff695f4eafe811f50149091ed2c2d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627c275fe87c88e6a2967f07a93b56ca0b05a243b0df2345bf010e3c90b0ced8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "660e07efccf3bdd995aed78c6dab687db0e21a2a214abc0133d99ba0c56f895a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c985bd52a6a7d5d5d1ff24160cfbe7bf92f8fefb97f252ab6897a31843f4e6d"
    sha256 cellar: :any_skip_relocation, ventura:       "067e82ac49516c947290c123987e399feee6211db8b73ba2b3b991e5e6aa1759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c222387e986d02cd6330254385c2e219773168946c59716c8013b1b4600be329"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
