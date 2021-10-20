class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.20.2",
      revision: "dcb4b76aa04c8be9a577ef2b9f0fde609e70b9e9"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e4e4cd57e69fadead0b8cdb7f85a593ff549002cf83b068673b4fa4b8bb8d31"
    sha256 cellar: :any_skip_relocation, big_sur:       "bcc5a120315228e579ffc1254ab3466800f6edc87401e028fbb8dc6d320f29ea"
    sha256 cellar: :any_skip_relocation, catalina:      "51c1ff0e5574b2560f8390b0c6d64c5ef13b1eb82464ffb7082906adc49de49b"
    sha256 cellar: :any_skip_relocation, mojave:        "51e7407f77307bb658ada8e26463ebe350dce6c883c28fe53d829cde70103818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a08c68395c9781fd54d2e066b25b09c257ad6a7e6f61e99ebb0587fd8848340"
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
