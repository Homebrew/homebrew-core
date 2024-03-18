class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.7.tar.gz"
  sha256 "d2f3dc3776a7a2aa378d5511d92e96baebaa35e22a8496e8087e7e58da01fd2e"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fb4db54da6b2415ab05f3b8573008c31498b3ccdccdf762fc16c8aac5f6fddc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "393f9ff30cf0eeb7a388194a75b332edf1cebdefbceafde2acf1b0e49ae554d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e53f85173da43ffed3c92dfc46e88b1faeee7997f0dcfa2b2397143744d9f17"
    sha256 cellar: :any_skip_relocation, sonoma:         "636304574df9da5bcebcfa0400e505c97b3820577e6e85c97b7fd0e773dbf338"
    sha256 cellar: :any_skip_relocation, ventura:        "9106ed44603a9f79934f41873059671d8736f1185389ad9fa58319ed3f368bae"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec01d45679f26575a407d3cc3cee7f0fe206fabd932ed8b67b078b319e78729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c2bc632d3d04e1a7a00d8c6cbd363f13cbcd3e1d6eee0444a16b7cab3bf6af"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

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
