class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.6.tar.gz"
  sha256 "b668801ca648ecf888687d7aa69d84c3f2c862f31b92076c443fdea77c984c58"
  license "MPL-2.0"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ae9c573b6210046ab4974fbb03f3ead33eebe961ffa04719f43f87340e0febe" => :big_sur
    sha256 "576e5b76d9ea50e2e68d6aa48ee434d26654a08f4c17f4dbb720aeafe59abc19" => :catalina
    sha256 "b7504895bfee3e1f3c9318de55a7c60cb256d3d433766f3178fcea7260c04863" => :mojave
    sha256 "f77ec3bd0fa7598d79ca30469140e989ddae59dbb5512d0aa22f0c21190dcd02" => :high_sierra
    sha256 "c52eaf11b850dea9c74b96d94157d25ee1912e52423628105c8b8d9240a2e52a" => :sierra
    sha256 "bb39c88ad9e3e5aa6b12ea08bbd6ec2b31601d0c14f943aaaf10bfcf14cc5b8d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.appVersion=#{version}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/consul-backinator --version 2>&1").strip

    assert_match "[Error] Failed to backup key data:",
      shell_output("#{bin}/consul-backinator backup 2>&1", 1)
  end
end
