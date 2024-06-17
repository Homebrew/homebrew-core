class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://github.com/bschaatsbergen/cidr/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ce3d0bd65ba9b74c3c56646f1a6b58a712ad622ace1cb8c1b72bf9f6b6d44bba"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae215e663006801d31126fe27f48837684ad6b1b64ee4d26695face667bed495"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3670db621c237ce9040a5bfcef371cbadb18bdaab15cb4d2f39ec17f79b6e2ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f443e1ab26996941cbff63b7f9c940a2482604870702bfab14d70c7eaaed336"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff90244ebada45a81ae12bc461f1c4b2c0e88a09fccad9b3a7d5c45718e52c9a"
    sha256 cellar: :any_skip_relocation, ventura:        "166fe35bf94f2484fee8246d15977a11e4660426d533a4ab63ffb309f8bf6377"
    sha256 cellar: :any_skip_relocation, monterey:       "769be268a5d810daed3c4211f1eef872b35180321ce3730f8090a7ac3c908c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47fc7c12caef7ec7ed404fdb794bbdf8bd0d9b37a9b7a53fd51a621ba268a2d2"
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
