class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "1879b2e155679241560ce805965bbd7ac5fb1b602115d97b2b31afe8a0964051"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aca372ab0f9ac3193e6b38ef76c3ed21bbfb5bd787a2013414719e24b8933044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a0ec54f97f7cd90c4c3b350d9dceab616aeafccd1d6cb3049dab9da4e2f77f2"
    sha256 cellar: :any_skip_relocation, monterey:       "8107cd641cf752fae921656ec4f82779c6de7346063b4107a25611603336ee42"
    sha256 cellar: :any_skip_relocation, big_sur:        "593ffda8687757f843c3bcd3194a71d5b3a427cc9c54e37aa0fac05f60b9077a"
    sha256 cellar: :any_skip_relocation, catalina:       "02db191b777cbdc5413938e2d57e483e42ddff1246be54c8389507b06d1ec7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0091e6a2af176fd1bff10eded3fc6c40c11068314f12b48b9fcd1c328b598b33"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
