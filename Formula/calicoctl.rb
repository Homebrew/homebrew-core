class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.15.0",
      revision: "7987fc57ae19d529c1289521f2e6371df90e2a4c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8de790a124ab604ed37a27516adc4037fd556b418798e7bcb0fb71658520c831" => :catalina
    sha256 "cc705142d894a3eb3e0385b0dfb4b892214a7655c08ef76751bc3907b9adbed8" => :mojave
    sha256 "d46e338642a4c1056cd4b16e10fd80415c8519364072c303f4b3a2c36946ccd7" => :high_sierra
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
