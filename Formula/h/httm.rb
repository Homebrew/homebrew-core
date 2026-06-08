class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.50.0.tar.gz"
  sha256 "d9e5f35a15c1049058bc8747f83ef3641b543675d211f7a890a310f55574bf26"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c680c62ac889ad5d43e0e85b6974f0cb6487700c38ea0d1dc13b4610413dba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be74642ffea38dc04655bd1a8edf779f612871cbb9d0bba356db5956b96fa7f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3440ce5dfc5bce789ba0d94eafbfdc9ff54e8c85ab1b5bcb1c83e0859f6312a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc50d3d0074db64f7808dfc7cdc24b754b74406fade276a1b40ee34472a2254f"
    sha256 cellar: :any,                 arm64_linux:   "c87df5318702fd39ac2495dd873f84a4d673b1f12b0c145e911165d52dc84870"
    sha256 cellar: :any,                 x86_64_linux:  "1f2baf75b7791358344baf15feb2fc5a2df7251f8e908ad9988fd8ff2a606657"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", *std_cargo_args(features: ["xattrs", "acls"])
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
