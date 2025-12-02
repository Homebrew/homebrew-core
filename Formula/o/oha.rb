class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "52a6441eefe90a3739901a2758a7b0566e6f61d60ae0c5c1808fe77daab863f6"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23ee616ca656294fcf8da729aaa2f5d5907ab583b2a5b323744d7b371a34369c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f68e0f8b0c0360f01c680fc8c0512143824a1f0cc2dbd9eceb83f2f2e8bc8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652f6177be359da476699a62c13c18884a21471e60919aa40b1e4af8c7c26fdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4517e6f3d94a8479f2b914f3584dac89b465d4ab26f3a6f86b9fa6786f410ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42d3ca0fe02072c60f121f4285f957504574bcaa4ad46037cb2d860567ad276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0689bdc72c7500f9678a8980e27c321c66ef471abf9fda27cf321d88a3916e1"
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
