class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.17.1",
      revision: "8871aca3dc0b30d6143031e46498b648e153da2a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c8ab9bc075972169714a81a0ae28d7ede8b34874e3364e2875c4cae6024f89c" => :big_sur
    sha256 "0265695b4b17ae5a6a3ae4b425a382b95a28b655356ac1b6bfc632ba50ea3335" => :catalina
    sha256 "2c80d37601f74353275ffcf492ca12039e3d8dfc89f9c520844bba9073a16ed1" => :mojave
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
