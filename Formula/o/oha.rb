class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "2f0448ccaf561a55b90da9dabe1707e4788dc0743dc34ab0621d99f60201c348"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54df364aa3c5fc5dde6796fe3c2544ed79937589c9fec975dee291632815ea2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6910f582f4b962c2d3c7eab143491b6453c36938d85500d6164b6cec25f701c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1566e0c623e509169050ee9cb180144d5c15889a3dad7e471f285a6190a55a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df7eeb03187b9258dd06f627ed93567865315d5c99b3fa01682ba36efb972c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9abd021241ca1cedd700471bdafc6ab19b2822ced8f2a6611d7c66cd2169d543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cdae1c9bc6797eda4e7a7384df7d65e62be88fac4bcd7ddcd75e29e18d61d7a"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
