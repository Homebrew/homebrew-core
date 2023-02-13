class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.21.1.tar.gz"
  sha256 "8b591088042c6aa332181e2f949d19e8d0ba70e8efaf8e657dce10e0dcc2c299"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "343138dc3885770f6e399326e3bf891a2658abff81e80242328fbb8a146db57e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f08fb262807598362c580cea59a9c40204b7d59247e1ddf516c76ba318da36e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82c0161cf487a8155fb0bb5ca58d0ac25d1d1467eedd9102c4b185e2cdd1ef13"
    sha256 cellar: :any_skip_relocation, ventura:        "655ebd80a09f4b58aa464d7d57cbd0fa868451b9d33f96c24efb3a08f3ff2777"
    sha256 cellar: :any_skip_relocation, monterey:       "af640001b640107c05f4e81d1611d6e590d036510050e09f785629c4ac9f9353"
    sha256 cellar: :any_skip_relocation, big_sur:        "70295f9649b45d54b1477bfc2ba6ea31e06173ee7e108765f01cf6c607a1d5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e814096e1bea399c8fcaa5e0a09762766031d4ef6876fc1ecc006e35a3ba57"
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
