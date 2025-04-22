class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "fb6b6020f46da25d47297bc4ef6532d05ab2b4a6e15d2b2fa604c94332d29106"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b24849890d88b43caff250678f08011abb5619f9477bdf0dde46cc66c4bdff7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2aa5db2dabbad41ac44dc6466c5634bb7f0ef76f3a483ee54baf5d8c151cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5a1b929a0b723b86fb32e5d05f0679567ab10e3f31b9f4f7b4e9439eeb8a91a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5d2b361d8301fbdb0c7cfbd14c237e3c74db5a729c808d134edec50f76633aa"
    sha256 cellar: :any_skip_relocation, ventura:       "01e81f1daf0bb75b4ce93605f78a74bb7ec2d7cc6c826ecb69f28b279dfa1122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d3aa5609f4e2e052f6085a4429b31ea559f5b63610c0dfe0f5786de32cdb1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ae34dc9053eb50a6399cd14ccadc01728801f0b1b69f3db01d16fa805ceff1"
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
