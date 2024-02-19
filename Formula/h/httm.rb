class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.36.2.tar.gz"
  sha256 "e5d0a4dd77d4b3772eb24005a68cf35455d3e1db9cf7eeb6cde0a06429b3a6e5"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89e8cfbc59c80a1784b095bd336f9def87b11ddaed950c68dc9e7dbb6087bef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6f5a6413e1a0a5405336883605cfd23266d188b8432b7250212f6cb4f02e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4ce51d0ddb74a5fdaad0e821bc4da6b25d7eb2a5502f8ed61aab1fffd761aba"
    sha256 cellar: :any_skip_relocation, sonoma:         "29bd7e24d433fed70b02a3757990c3614b797d2a1b790667bd7ce4d8686d2436"
    sha256 cellar: :any_skip_relocation, ventura:        "2fa1ec463bad052183e3801b44e6d1f84b189b38b44b5ce8d987c0d8f1f1278a"
    sha256 cellar: :any_skip_relocation, monterey:       "a94b1b56deec4c0d56c5bcc8c9fbb3481bb9855d26ad314162f8e3f03d70461a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5760c6f4980b41dc80266b81c4a2e1834e19ce3b68fbbb1e9a33d7af40f742"
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
