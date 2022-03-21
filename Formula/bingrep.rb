class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.10.0.tar.gz"
  sha256 "3bc4ebaf179d72b82277e7130d44c15e2cc646d388124d0acdb2ca5f33e93af6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed7cfc283a7e589a22b0751e1c416500a59ce073f4d3577e41052d5c28a8d848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c926b06c7d43b625a339c3088f72f965aec3a3f8428fc4a98f39d87b6c867d7"
    sha256 cellar: :any_skip_relocation, monterey:       "49ea632d7836a2c89456c0832daabc478268c6a0b321b4f41c8831b20401c725"
    sha256 cellar: :any_skip_relocation, big_sur:        "f48aa8ad89841d14d4693bdab7819cd77081473f9e4dee3d695e2bef84d94100"
    sha256 cellar: :any_skip_relocation, catalina:       "d4f99329364718a9b25f71bae476860ada92d4ce378a67746d731df63748a0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4cfd308fc82bc518538dbaf2dbe0fea09fec0e965767088b1402f0fbbd9c84"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
