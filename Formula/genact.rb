class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v0.11.0.tar.gz"
  sha256 "6ec8c1e717f78968c825513ae86dfc7cf5d71798b94b97d012cb185a4ca5a0a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48325385454894eddd9bf33bad8a370ca36a1ea126bc8981307c9f1d735782bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "faa9f1370b20ac2d6e92eaa5be5bf376f7ef8ba85dac841f735ccf491f9c4b4f"
    sha256 cellar: :any_skip_relocation, catalina:      "4d94d3fd54d7821be5684690520cfacb13f8d9d3741edd927b0f8b9829e1d63f"
    sha256 cellar: :any_skip_relocation, mojave:        "fb724747b034a14552cc66c88126ed22a6f4c001c9d63b3a437fdb8a4c2ad86e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f164ea3f660c60ca1071bba73b6d2b7d0ba3bc9e6e54126bfadf5ee4212d9238"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
