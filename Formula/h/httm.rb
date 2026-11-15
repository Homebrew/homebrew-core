class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.51.1.tar.gz"
  sha256 "4c7e8947d41478f6f995046987614a1903e35766fe8a1a8e0847de7a7b805b24"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3d65f41ccaaf9d42e59bb8411426f38615db96752cbb674e6219ba507b3e88e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f093959bdae23e8ecee8df9b8bd3c5998dce40740d53b8c8a30b01df85fe3c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3a761da79e41be6c9f49ab7d7afc9f8cab9570bb6344618fe1694fbeceb8fb4"
    sha256 cellar: :any,                 arm64_linux:       "fb72b77786d49a55b94596b8a2ba7c03046554ddba1c98b6255af046493cfde2"
    sha256 cellar: :any,                 x86_64_linux:      "4600d73a9dd8a9b781666b487c3f8f0bb56b235a742d1028de45b123326547c9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
