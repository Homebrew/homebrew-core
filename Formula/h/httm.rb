class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.30.2.tar.gz"
  sha256 "0f9595b83ab01dcc4c579a81f267eb759e93d65fd98cdd443b2d16b7da39b744"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e25a1e3bb600fbf40a20abbbb094a906c0cc03ae1160ff07dc586f0d148f7031"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09628422bc3c0b1c458f5f416944abf196e102254ab622b8d57b50423dc9da0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dede129153366eafbbe06f531089c34454ea8fb6ecfddb38a7abd0322157ecd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd3dfdb1f24633eb87276cd523e62d275bc195ecd260a45de52f5c4fb665657f"
    sha256 cellar: :any_skip_relocation, ventura:        "0557f2df75a01a516a0d0a6c1e406edddbf17f48e497629f1be14f5057e1ead1"
    sha256 cellar: :any_skip_relocation, monterey:       "3c3a3862e88d0c6639f0bd4e9c48565fa477ce6583a203555288a1d2e4103286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ff4dcc4fbfe811e5cc9048fb0909ea2c5c7a7a7b85b16a8a0e228a438dd7d4"
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
