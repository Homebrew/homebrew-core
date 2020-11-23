class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.17.0",
      revision: "0e7fc7f706cb6816f344992a2aaa161e42c7653c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "aea6d2416c454737280dc12c90316b3baadb14c2c6f978c4e32bbcf28d872c95" => :big_sur
    sha256 "459e00f53636ccc0cad6370c60c9ba7066597275295a18ccc95d58915d6a898a" => :catalina
    sha256 "919fed422ef5a553ef4242ea90d918eeaef02a7c1d1daa9063d6dc1478b3f551" => :mojave
    sha256 "1692ad26fca5295c4f359576c4a87f20f0abaa3b864c7bc2a7fd732f6b1db94e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
    system "go", "build", *std_go_args,
                          "-ldflags", "-X #{commands}.VERSION=#{stable.specs[:tag]} " \
                                      "-X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} " \
                                      "-s -w",
                          "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
