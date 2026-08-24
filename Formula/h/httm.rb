class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.50.2.tar.gz"
  sha256 "5fbe0c376c2fa3d8cd32cebfb4bde1e4980b50892c52b3be242894bc11213614"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2619dd691ee1322d2de05d644d213b2512f7fe5017acca3a0c22be49a0f58690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d82f7d23b1534c62b293b516e3faa9115db54bcf9f3c20bab3d89a46ec890b16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f910da202475377a0715bd0e0685317bd28831340e044c5385c4dbf9735d2c3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e6b1dc202c434845e13b9af9f89f2c633f36c4244c308ea00dcab0e7916115e"
    sha256 cellar: :any,                 arm64_linux:   "9dc202cab2732739a1ac117b1ef334f3432d01f716a2af1708118369b3ca41b9"
    sha256 cellar: :any,                 x86_64_linux:  "d5dce89aa0608882a36981e927d03d95ff6b59f7e9a77eef8f8c23c5d2591be9"
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
