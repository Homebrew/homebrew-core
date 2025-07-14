class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.48.4.tar.gz"
  sha256 "4573d9057550bc257e4828ace92b18382177b7cd379dac68aef529deea927e8a"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2654463c9920d9f9e7a90934975e718537249b28ded64e90839a0a2525052b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f6bd6fd09a59e8aec9821c1d5a80c5d46f1e9d7d938a39e6b15165f72e8dab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c84e0476db318619c3facfbd9801eda23fc053a00dac46630848886414c40a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f898c8e4c9214d208ac57e74e7907d3c228f5d63c30c3232919f2821fd9f787"
    sha256 cellar: :any_skip_relocation, ventura:       "2c37c472d4cb056201ca596ee52ee99596e6f51870204e30ba97245fd1e73a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff15f6abe603437e5ade8ffada96b2bea30cad86b99c1c1dcd5611bf6a671871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "868439da605a20aaf861b7d0994fafd882afe0ad8e593ffe7e6664492c868904"
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
