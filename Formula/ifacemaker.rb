class Ifacemaker < Formula
  desc "Generate interfaces from structure methods"
  homepage "https://github.com/vburenin/ifacemaker"
  url "https://github.com/vburenin/ifacemaker/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9928795e3f06172106993bb98af248877f4998f44bdaa020676a1431de33ef72"
  license "Apache-2.0"
  head "https://github.com/vburenin/ifacemaker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22085cff161ce23c252e0d1780662e4dd5491ae0e5c529a32aa988cfcf92a3a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22085cff161ce23c252e0d1780662e4dd5491ae0e5c529a32aa988cfcf92a3a2"
    sha256 cellar: :any_skip_relocation, monterey:       "2ff04b231be4840bf83ff3afc38f0ad27452ddcd79f4ac43e5a42bad7585dc1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ff04b231be4840bf83ff3afc38f0ad27452ddcd79f4ac43e5a42bad7585dc1c"
    sha256 cellar: :any_skip_relocation, catalina:       "2ff04b231be4840bf83ff3afc38f0ad27452ddcd79f4ac43e5a42bad7585dc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75c226bb22000f3e24951913dfc4d1566e88f2c415bdcadf51262588e1ebd23d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"human.go").write <<~EOS
      package main

      type Human struct {
        name string
      }

      // Returns the name of our Human.
      func (h *Human) GetName() string {
        return h.name
      }
    EOS

    output = shell_output("#{bin}/ifacemaker -f human.go -s Human -i HumanIface -p humantest " \
                          "-y \"HumanIface makes human interaction easy\"" \
                          "-c \"DONT EDIT: Auto generated\"")
    assert_match "type HumanIface interface", output
  end
end
