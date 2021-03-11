class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.18.1",
      revision: "911f383f027510c74dbab168c767844d2854a814"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21df2aba4df956bd81718b6fe7b4abb29be68e84687693b4a81238673e35c9ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cab42414ed377f942ed61ee213b7005808d908acdf92fa5f596bf8a56712f31"
    sha256 cellar: :any_skip_relocation, catalina:      "8761c4225d2b4684f5365d7170b5b90a63eb9947f82116fac05355edf4b5cfb4"
    sha256 cellar: :any_skip_relocation, mojave:        "a96d26426d7e69d7f505b150116667bb274037baad63b97a302699f00b4dc35f"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/v3/calicoctl/commands"
    system "go", "build", *std_go_args,
                          "-ldflags", "-X #{commands}.VERSION=#{version} " \
                                      "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
                                      "-s -w",
                          "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
