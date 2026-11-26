class Ifacemaker < Formula
  desc "Generate interfaces from structure methods"
  homepage "https://github.com/vburenin/ifacemaker"
  url "https://github.com/vburenin/ifacemaker/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "55e0dfc64213827ee984048634cf4af29e96f02a839542f719c807fb6a204473"
  license "Apache-2.0"
  head "https://github.com/vburenin/ifacemaker.git", branch: "master"

  bottle do
    manifest_sha256 "665723f51db70a0f38609941bdb7f0a5f90bae26c348c0ee661baecbf3dfd3f5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "559fb93832e542351707abd4ffa96bea989e1f0bd3c750937e1703b7e273c21b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "559fb93832e542351707abd4ffa96bea989e1f0bd3c750937e1703b7e273c21b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "559fb93832e542351707abd4ffa96bea989e1f0bd3c750937e1703b7e273c21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce01b1d842c6d89166b335e99425a96f9aa20fcce26ce6fb5aecc5873b341f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "793fa810bd8e85b386c146096d35d3ce623d7a384d63556a8aac81287aec396f"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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
                          "-y \"HumanIface makes human interaction easy\" " \
                          "-c \"DONT EDIT: Auto generated\"")
    assert_match "type HumanIface interface", output
  end
end
