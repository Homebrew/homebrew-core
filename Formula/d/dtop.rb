class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "9557fe2425266c5820250f6cbe3421744b58d54bca792bcc9f4f7c68b76e30e1"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f68faad65126e0b37fc8bad1eb1f01b111903b3e7f590557ec79309dc18b1d07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "911bc5c00b2f849f899c9a2a82693d67ee9cf52a82e9c08e3910af863489744c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928b46f53f505040c31440aec30608c5d51f940fe97c510cc5e1861c5ca02664"
    sha256 cellar: :any_skip_relocation, sonoma:        "a71c06dc1fc3700eb1d90afea6f1274a2294a048fb73fc009f90a6ea9497212a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89a39e13e80741582e7f9fad24d28d3456e7a66b1a712fa96885b3353d7cdf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5221d515bd2edc7675ebc7ca2a293f86585637731c9ed1aac9330d11757727"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
