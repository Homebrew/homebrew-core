class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.1.5.tar.gz"
  sha256 "e9b146dfdb13729bc760a9cc0954d85436f35a72e8d92b7bc476204fdb5e82d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c4068b224dd0a70b4ce6b586fbf7a18adf7b78bb1acf272ebc5c94dc3c745eb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "c78a6f57640a001bf299ef6f5a3ffa39d1194d5509dd455bacdfe4375ea5ee96"
    sha256 cellar: :any_skip_relocation, catalina:      "e3b5d4efdd0ecc475f536a1438f872b70ce12afef68d0b2bcd2ee1be5540f275"
    sha256 cellar: :any_skip_relocation, mojave:        "bccea2c00805fb3e58f3db3644c10c475c1550a74d89ca0601aaf4cc9653d5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a5c0f81eb2fefcd46ad51a398371b02619557f316cbe1ccd32413df380d550"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
