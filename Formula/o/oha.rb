class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "c09dce5de2020529a03309b96c98e51f6b94c63a73191c281df32024d62c19a7"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "720dacc70b5da848322d14e2c123629f17d62f8d38795e60a334c3137cad6918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "847b9e1e0f85d79c3c77405ae08152cb4ddfdfa8e33fcd05c7e3f4619a327de1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd38248ad25b39a3c0230aa6ea6cdf25387461d1f5f12f7f5352dde59790a44e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1bfbf08156b676f74baae9defdef6986bc2b8c8d3cf3b914140619292688d52"
    sha256 cellar: :any_skip_relocation, ventura:       "ab9eae1e4a28088cfd64254288d77007c043ab90122401b81a01dd754f9debe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7319f4969f55f0a581e0d233b5593fd54b32403decea445f58510456e21b588a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3866d6dcf4784ce901f91d15abc57a7fb6ab940917137236d4a8fd3750ce50"
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
