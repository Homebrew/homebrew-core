class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "1879b2e155679241560ce805965bbd7ac5fb1b602115d97b2b31afe8a0964051"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f380a696b47818214809005cc541b3819ab64d5b02ced8338885a586611bc697"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dcda276bb676349d50e7a9b2f9c9a1e194856ebf25d7c8fddd0a424e03f46c7"
    sha256 cellar: :any_skip_relocation, monterey:       "4c72a4d693a10d86b361ac2c11f0f108c4fd9f3926ae740cd4f985b9c83fcbf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb394e85011cb29258c4e77f09e7736936a01f811edf547ef8ade4a4c8331496"
    sha256 cellar: :any_skip_relocation, catalina:       "0d53b75040e1ed928438d1f3885a0eaebfee936d64e4100b76ffee39794d8680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25dc40acbc76d8dda06f61910dca1e62994f0966ab0405b20c6a1dcf1c49ebfe"
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
