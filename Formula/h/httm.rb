class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.46.6.tar.gz"
  sha256 "5530faa3a3364c8b2a399f403c9bfb4b94f7cd9efe08ecbf7f0d3eafd2eaf72c"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58e5b420385d3390cc17f89cb010c37a886e6aecb32689802ffa82140f40abb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9eab90d9c4f385c27e5d7a49cadc92db42989230e7d5c8c0106faae1e57279"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0ce73d0207758955a7b35ed60a378f3fda38ff8db058ad2ffa34edb1d812e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c8cf256cfa2341f900435f0f12c518918a53c14daae85d2edc393767b72e59f"
    sha256 cellar: :any_skip_relocation, ventura:       "7476a35f2ad66394c3f9983e9d6a5bc7b9ff0eb5dc40768a5965e103d9e47f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07590e41e3c7548e06a38d13e4fd8c13f51940262c4ddbf6ff0d2fa648515cff"
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
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
