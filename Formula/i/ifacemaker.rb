class Ifacemaker < Formula
  desc "Generate interfaces from structure methods"
  homepage "https://github.com/vburenin/ifacemaker"
  url "https://github.com/vburenin/ifacemaker/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "c14fb68397812f4ac487a2626262396d9f9a01a4da39023713795b04b5714a83"
  license "Apache-2.0"
  head "https://github.com/vburenin/ifacemaker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f068783b343a4c9cc6176390f2757260ae8139dba2a9b855f8303e1f1a29ec4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f068783b343a4c9cc6176390f2757260ae8139dba2a9b855f8303e1f1a29ec4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f068783b343a4c9cc6176390f2757260ae8139dba2a9b855f8303e1f1a29ec4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2969a8f5413225d7f830df6a36fe0ec3d471f57d1134ee9652bf2ad9997bb93e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ed1d0c5420da65795d9753ca60beef3d5ccd908df611146549f4fd7f54709bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10b0f3cdec36942d23626f4cf8f7b8eb05f47c531e965349df383ef1385cbcad"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"human.go").write <<~GO
      package main

      type Human struct {
        name string
      }

      // Returns the name of our Human.
      func (h *Human) GetName() string {
        return h.name
      }
    GO

    output = shell_output("#{bin}/ifacemaker -f human.go -s Human -i HumanIface -p humantest " \
                          "-y \"HumanIface makes human interaction easy\"" \
                          "-c \"DONT EDIT: Auto generated\"")
    assert_match "type HumanIface interface", output
  end
end
