class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.19.1",
      revision: "6fc0db96a3d2df7bd2eb0929f9c3d327380b0ed0"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "622d966ce5503d359a68fb9095840e193e46157d518916fd00e7fe352872edd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "e89e80c43a6f743530c42bb6b5e371bb449f64dda3bc1671f01f464905be9c18"
    sha256 cellar: :any_skip_relocation, catalina:      "2f76e3802048775984e9cdd7db889130d158a983d6b52543f22ee58de6b7ea34"
    sha256 cellar: :any_skip_relocation, mojave:        "53465951c381d8fadcf36894e78dbd92f300785f6562b98bbf519efabcd47aae"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/v3/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
