class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.28.4.tar.gz"
  sha256 "5c36065072b4d17ef77c9b81a9f892587689085873e8830c4e2b0da6526d6078"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ad46c5e3f3d4cc0625f024da94866f214daa15b7107373cefb4c9cc4e06ae74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19b337830b1efaf887fb1e516194aeb19aeda3e3154e6568216054f2081a9bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2729f45292aa2e9e6091d6e8332b6a57db8308ad065c197629fb93fa3f138b0f"
    sha256 cellar: :any_skip_relocation, ventura:        "8d69c27b51581555ef695bda712c9c23a9f326994075f73a4cdec4204da8551f"
    sha256 cellar: :any_skip_relocation, monterey:       "1dcee7d4b186ab8eb36f8860881ccd19f0f1519c47436f82e2ba65054153d27d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2541d94fed147ecc183ceb4ce4c5256b829a800854b02cae41e64f4e078e3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "084fc3dfce7aa160ebdb2d1c1c8a3aff4d56a645f07342ebef62c4db1c8f8a63"
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
