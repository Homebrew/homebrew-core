class Ifacemaker < Formula
  desc "Generate interfaces from structure methods"
  homepage "https://github.com/vburenin/ifacemaker"
  url "https://github.com/vburenin/ifacemaker/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9928795e3f06172106993bb98af248877f4998f44bdaa020676a1431de33ef72"
  license "Apache-2.0"
  head "https://github.com/vburenin/ifacemaker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad9412e1b854ee824e7e02094591fa390a91669407bfe918d41273ac9e39b10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fad9412e1b854ee824e7e02094591fa390a91669407bfe918d41273ac9e39b10"
    sha256 cellar: :any_skip_relocation, monterey:       "9b7cce651aa5e1078136f44d975b0cb82edadda113c36c169cc02ea8ead0a298"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b7cce651aa5e1078136f44d975b0cb82edadda113c36c169cc02ea8ead0a298"
    sha256 cellar: :any_skip_relocation, catalina:       "9b7cce651aa5e1078136f44d975b0cb82edadda113c36c169cc02ea8ead0a298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3030a7be7c380c654ef1434fe106932f6c897eab9675c15da34239b3dec0305"
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
