class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https://github.com/mufeedvh/pdfrip"
  url "https://github.com/mufeedvh/pdfrip/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "60f284d79bac98c97e6eaa1a2f29d66055de5b3c8a129eb14b24057a7cb31cd3"
  license "MIT"
  head "https://github.com/mufeedvh/pdfrip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bca08e27db986d69640df5ab539f1b84fcaada7f43d6f8235d472bfb26acc1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92eafcb03fc927dbe7a94aa8b5657038621d342f1405c2a09d6766a94ee04231"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6c3dfc1b88440a91d4cdcdf76699599cf6955b8c31d1376bbff00b13751ead1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d5def9d0760ae745a23e26a0b37afb953a340ea6de90940a3f218b0dc369ebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1d72c6cfcec8a572e0e8c3e07acea03120fb692c321c8c88993dac530a127e0"
    sha256 cellar: :any_skip_relocation, ventura:        "83cd8a56b4a4238f6ccf0dca5519393686ec2c4e144d035841c71228637a7933"
    sha256 cellar: :any_skip_relocation, monterey:       "cf71e60e04dc370096a46ba62694e46749dbeaf9e5fbdd9050bd355f0d8be40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "311c5aacf5d23a6e692524c39f632bac0bc0a4984b0a5de34ff452f6490d9a28"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfrip --version")

    touch testpath/"test.pdf"
    output = shell_output("#{bin}/pdfrip -f test.pdf range 1 5 2>&1")
    assert_match "Failed to crack file", output
  end
end
