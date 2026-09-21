class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.51.0.tar.gz"
  sha256 "4c83d3a54aa2b4089e8009049dcf61f501ede0d5b6d03691b8d783bd43bb960b"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "937e9536209a61f1bc629ab7ca6a4d10ae4e1b3c39154f8014b7536970aab060"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06a9a1e96371482a45cf87044cebc8ca7df154362673525db291f44dc515d957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f72e1d233cefe264f1a4f9618792dba605955e80ca7e0bf31077387b5a42eaf"
    sha256 cellar: :any,                 arm64_linux:       "8c8093a9c667079555b12ef32d26dfd2bf4036874e8f96e8320d81dd7e75d420"
    sha256 cellar: :any,                 x86_64_linux:      "bde98379a2230dca7f38433924b97ae71789bbe806feb1506d2acd9dd023e14d"
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
    assert_match version.to_s, shell_output("#{bin}/httm --version")

    touch testpath/"foo"
    output = shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1)
    assert_match "WARN: httm could not identify any proximate dataset", output
    assert_match "ERROR: Requested paths do not currently exist", output
  end
end
