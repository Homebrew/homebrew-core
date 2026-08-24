class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "89c8bcb656dbee17cccfd4b0e676523bc1f3ff34c63a84ab8327646ce72984c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2157406b62f3846a489de468d8810ba0e017ec2699fc2e5a10273e4e3815cedc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b4a02f7b5bc94f6338628bef09657161df6c3d66d07f0818caff3d68f40f8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89d689a13c2716c688b523b48ba752f5be0a6596e3418e252f13897ca360809b"
    sha256 cellar: :any_skip_relocation, sonoma:        "03fbb45273441c66cba3983caf8125aaf7c6463f2c67e8116d8c8a08829855f2"
    sha256 cellar: :any,                 arm64_linux:   "90d6673398d863e399af52e243044ea11122a4ee9e7407e215c3ae5178a62dba"
    sha256 cellar: :any,                 x86_64_linux:  "f06cd8c76c4f8503842fc2cd2cf28826cd3c7b1b2615e87df1a6e48a62cf361d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
