class Goku < Formula
  desc "HTTP load testing tool"
  homepage "https://github.com/jcaromiq/goku"
  url "https://github.com/jcaromiq/goku/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "84432c749c2a528ac5ad6f47261eedc678ba4a87415bbacfa157e39821f2a4d5"
  license "MIT"
  head "https://github.com/jcaromiq/goku.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d6407e5fdade887008fde8a4d62d2386e5a2b8026344ff1281b40824b3ce3a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f61c3410fa15a74c3e9d631117be82d778c81fdc5eeaca63d7f0a9ca779e2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65cb276e43ea8ab19bfc7570cefff14928f01c61b266631915be761a4dd1964f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d9857b2559d6910f97afaf7ccda968a7e06e5862b61325a9530ecd1f39cb375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fae4eab315fc29a9bb00d18c5db79955358787eb09c5a39a07c5b11c3827574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19bd242cddad6a7b15aac7fc5f7615cbf230431332f876c485a3705f7bf3b893"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    output = shell_output("#{bin}/goku --target https://httpbin.org/get")
    assert_match "kamehameha to https://httpbin.org/get with 1 concurrent clients and 1 total iterations", output

    assert_match version.to_s, shell_output("#{bin}/goku --version")
  end
end
