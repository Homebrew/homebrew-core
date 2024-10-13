class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "9d72d6d1523f32d91fc06c2063e5e34a724a0a2799929aae7f1bb6582f8246b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d6c2a86406153bdbc9df02dbe63b5ed0128dc2a5f672b19bfcdaa0604c1ac72d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71846aea29a40741ea36933822898fe0396bee2df3f21fe67be9e4944425840c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "696538039df77ee84503a2954d9036367cc9efd79b2930f66ecec1fe26ce40d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b0c9a9876bfff9f0f750c38b384efc1f36b66e1a7ce2dc46990eb9cccbfd88"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c16443a77c65848c5766a77ca3708b80ae2b8e9af23c2dd87eb73db4c8f8817"
    sha256 cellar: :any_skip_relocation, ventura:        "949eb6b1a1cb53e3204c3812f60e8eaf8ebd0b7156dae6682d9c2e5bd48ef41c"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8273cdc0520a941e9e2696272bb2d148322f9784ce808627729ccf19e900f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1e67bc931013ad585f612c77368b6061b23ab9188ac1393e497063419a10cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
