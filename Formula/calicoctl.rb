class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.14.0",
      :revision => "c97876ba2dfa524c121af82f16e46b5167bd19f5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c54ed319108c12dfc2240485e47201d2ea9a24d46103703db2bbfbf8ec9a79f4" => :catalina
    sha256 "733acfb76724283e82f1d888ee452fcd8e377749d464925c145bad18551604a7" => :mojave
    sha256 "af30a792d0df3653c9cc0fe0620471aac40db94319fcee83229d80dfd253d346" => :high_sierra
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
