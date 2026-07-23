class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "9490f81539664dd7e9749c63866fb2892a7d4a55cc83002f17fbdb07e08b2c36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f27be3c71d3d3a8e041f53206fb2dc967e76cd49b5d7dd6bb88b03145c4340e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc57b6844b9fcb55b6d1b2c64e49e2bbd1f39aa456e0aff5765e1c93b844d520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ed0f76a9e81e99e09b649a3783e9f4971809468ac2750ac53c0fbcf867a941"
    sha256 cellar: :any_skip_relocation, sonoma:        "d503e4afd2e44fa08715b5bcfd9d0016bffa4905cfa86d06a163c0f87e093ac8"
    sha256 cellar: :any,                 arm64_linux:   "79198f1e440244bfa241bf52311406deb58d9fac80d2c8c8ab6ae0948cb3aa77"
    sha256 cellar: :any,                 x86_64_linux:  "e544c01aeab0950ab4bf9ef26b3b7ae1e7c1e08782a47c6f9247f49cb5052b07"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
