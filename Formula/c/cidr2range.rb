class Cidr2range < Formula
  desc "Converts CIDRs to IP ranges"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/cidr2range-3.3.3.tar.gz"
  sha256 "6e85038d745515b22ed4c19d2400d5d8f7c4d6c9099d6fdf4a88c1d4ad4e1a74"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cidr2range[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56e6039e2c505b4816817547a268328f3d281aa10c2005801c9c7973d7fac493"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56e6039e2c505b4816817547a268328f3d281aa10c2005801c9c7973d7fac493"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56e6039e2c505b4816817547a268328f3d281aa10c2005801c9c7973d7fac493"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bbf42ecbcb2cc9ac2ca8c3c52e2ac265852ffc8da9d9f55b21d1cf5130c4244b"
    sha256 cellar: :any,                 x86_64_linux:      "f3aed044873acf8e5e4d904c5f02ab8f342a3297619737894dbedeea2010d611"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./cidr2range"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/cidr2range --version").chomp
    assert_equal "1.1.1.0-1.1.1.3", shell_output("#{bin}/cidr2range 1.1.1.0/30").chomp
    assert_equal "0.0.0.0-255.255.255.255", shell_output("#{bin}/cidr2range 1.1.1.0/0").chomp
  end
end
