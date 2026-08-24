class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "8d856e2850efb521c0a1f8efed530eeaeebea34d09c6edc19a42dc5e13b14287"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbd6ca66167b92068f32f27955dc2cc24b03ae1150c3fab1d694fcfbc1b68c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aaf7ed96e64b1a5a005b701677a6fbb7865d9de35320e70b4e703546ae338e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4473565fed70137bbeeb2319eaa7bd34ce12ab87561e5e44dd60d4505ef65ca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd7675fcb19378bd8b71aafb84e5d4163b245430e2548b0344b37a768c6b716a"
    sha256 cellar: :any,                 arm64_linux:   "86d1bf8ec57ff6f0625ed1a861e1fa43310f9676ef58f7dc66b32d3abc6c0911"
    sha256 cellar: :any,                 x86_64_linux:  "bc241c2c44580cb730c5018cd29aa61584d541de196b664c63ff091dbb464b2b"
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
