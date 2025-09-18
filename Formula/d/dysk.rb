class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "dbf81a3f22282c6e9b3205b00c6e58e54d85e5ed163b1384076f4eb4aa4f5e0f"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8538715ee9a473304d602ca1f1b62883b97bf748b2b848c03a0a04c1c7abfcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69a722cf0f7880bff7c8a4eca3e7f548ca41e19698cba2a74ccee9b6a7f46e4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d4c4933d05dca6f4f754772b515ca38ee3871f626437a8ec59c0f4619138df7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f45d5c56bc93ca60b8b5020aaeb7629dcee9769fb6537b8acdc67f2ee4bbfe8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "25b57d97916d4dd66fd5074cfb1a782ee5627b8356299566f348ab4be0632c02"
    sha256 cellar: :any_skip_relocation, ventura:       "5cf1ee234654544f941a84fe880427e1db26d2d1a9337704eb05c8ae008c5eca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07f4e51836f75c1270a082e6e3ccdc3ec3f410797e6ca0469486d8834292d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ab30e421110c934b66a51778c2df4522e6ba89f25d98f5bd5b7148e28dd3a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
