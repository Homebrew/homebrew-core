class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.20.1.tar.gz"
  sha256 "8e6b1c172b149e83da3d22fda8fe6b7554932ff6f47a1e6cdfd93ddd426577f4"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f61df365ced5fe7bf2b50d96e0ebea71432385898896d259be1cfff43579e091"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "158f42487b62fca94c292b44484ef6716d21cef7e74fd8092875d0ea3791f80b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a0fcbc5d84371bcbbe0f79eec13feddefaf07fa8186b177d79be09840a01262"
    sha256 cellar: :any_skip_relocation, ventura:        "62d5511d46336ac69b3347ca3dd3043495ad32ab55f75d34d613ba6ceba7ae9d"
    sha256 cellar: :any_skip_relocation, monterey:       "189ef45e1341283e021a85cc8f954abf5e2c80e75612cb3bc0aa38932718ea9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "800dad7bf1a59ab1e87d7c0b80ff40669b5ec4ffdfd52a5972dedea4b9f54ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cd29d2a3a9d12aa733c6ebcf64f0cbc91bed6b9981cccf4ef3116c89651d09c"
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
