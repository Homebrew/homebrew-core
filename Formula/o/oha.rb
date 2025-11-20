class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "aee9a6a638fb32f9021105d7faa7c182eaa8bc7a17a7a9a96525d5d61b32ea51"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3615368bb9198de7c12473ee70abb7505226b8d5108ba23ec7a51d2d98176d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4abe7889517f4662264a0730dca034f4aec14b75e70f15b4cecc21598b8586a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac69d8483bea42988c7130dbbb8018cc5588bab2baec56c5ca94191f0f440a1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c064b5faadf5df3f08f1a1f46a272e8b1997d709232030c2d3a121edf508200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "458fb0ddd756ac20ac8b35b91e158de5bf39837c634fc5b089ce66b4f9ab311e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbb06a64b1986f9c5f14837c3877e39dd42182eb2a06f1a77f52eaf5888bd4d"
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
