class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.42.0.tar.gz"
  sha256 "21596aa61ecc6e15dac13851fe7a8e8ba13494c636b177613bb64a8f3a2e93b5"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d28647d8987694048b471d6b9cbf3e38a9864d74bdf3dbc81aef6f67bc0b096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b424ac3387ed4c5245d7e75cc4f93614a9d767ae0c3adc6bd93788b1b53916c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a941e9c9a19e9221ff1af963cc82fd6da64078d5b807201003bffde5dd8bce"
    sha256 cellar: :any_skip_relocation, sonoma:         "f21db1f867a2a02d3ca21ad1eb7ce6fbb4f722de9ba002e43b0416a2c0a606bc"
    sha256 cellar: :any_skip_relocation, ventura:        "84fc85e938fd05802236182e8c2cb660f2cd690396099505d7e5379d8f548dea"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1716e7cdbc6a1db82779a32594617a48df8e9c789c4f94f627efc45b8b51a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e9b77bb2066536b915958eeb4b1a4338333b8160bc00cde17eb2cf8b21f5d9"
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
