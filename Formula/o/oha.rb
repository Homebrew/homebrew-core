class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "e40a3898df0229ebea413f24527558a83d75df5cba2b970ece5aa9fad8fb12dc"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2a59ce7ff583d75795933ae29d8b91efc42f8f7debbb21db0e581ce99247ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea9528547af37cc252144138176c8e88b5a9e24a7cafa38d2fbfea02a77380cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f3a82b44db49a69c624bc9449f07645dbace03c6adf28878ec3c0efcaf322ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfef79baad15279bb9702e142de789f7ea2f241ba359524fff585ad335556ce9"
    sha256 cellar: :any_skip_relocation, ventura:       "568539d5cc451dd9055d244451b82b4e5b6baf7af5117c1c2b5836a9da355282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8cb8e85be4d0762850e093f0c3e742e93bb33afc4381621f91ebd635ea6a7b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8ccb80eef4bf079caff2c02669e6efaa64164eb86c60e570531e3ae8651d1c"
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
