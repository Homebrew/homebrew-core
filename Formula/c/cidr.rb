class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://github.com/bschaatsbergen/cidr/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ce3d0bd65ba9b74c3c56646f1a6b58a712ad622ace1cb8c1b72bf9f6b6d44bba"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "954a4ae2bea00e60565f5cd70b756c488ebbcb7440b375742a26cf968d6334cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7c74e841555e1dd7a2a11361e81378cf4e8274084f48445094cdbe0a1fda2aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce93979795e63d01c0f5b1f0bb7fcbdcecbd3b41483a461d18692790875f0dbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a601025529ac9cd8e1e010b8cd4ead7c963b4e9ad503c0260f9c048534cc063f"
    sha256 cellar: :any_skip_relocation, ventura:        "6c104cd86c3294b7a82c3fec3a304c7fed44de0c93a90825126bbff9fecedc1d"
    sha256 cellar: :any_skip_relocation, monterey:       "2e110a2578bcfdd8749259dfba64250e55d39750c01ad5a985e4d4dc20a17224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "490147e7760138e8c66e4575acda724d22f7f75ab22fdfde31f8c5f577613aa9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cidr/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cidr --version")
    assert_equal "65536\n", shell_output("#{bin}/cidr count 10.0.0.0/16")
    assert_equal "1\n", shell_output("#{bin}/cidr count 10.0.0.0/32")
    assert_equal "false\n", shell_output("#{bin}/cidr overlaps 10.106.147.0/24 10.106.149.0/23")
  end
end
