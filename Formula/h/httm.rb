class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.50.1.tar.gz"
  sha256 "06686bb2894fcd6e10ec32ba07d61040ecde3e79a7b9c891a56788bce3a42677"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfc4bc75ee68743169cb8b28a5aac03e374b8549cf8091491029590076349d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6499a59af852292f2559a8a0ac99aa4390053829d211583d40e0fc58d8b9938a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a839089f781c9b7d954f3591e340107e4d94899616003be4cd0e662a89818580"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4963cd05c33c6f422dca3f2a1f6e43f68bb7d6dfecd1d8f9ffec3322a7e4af"
    sha256 cellar: :any,                 arm64_linux:   "d92740ed5551e84aa95389f3494d4a5a38fd469d92f4c8ccd47ca3a6890a1cfa"
    sha256 cellar: :any,                 x86_64_linux:  "31682d0042ba32b6a80574a144d5f7699f644c0fa3142215d5301f2b62378a29"
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
