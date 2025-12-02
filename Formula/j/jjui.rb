class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "7e739c8cad3362d18e83d60458cb594a5851e3543607d90b9dd071a4c479c430"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "538df448e1aabdaa570af8f7aa1f578960b1384e77aabe68ceda85a5864c76c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538df448e1aabdaa570af8f7aa1f578960b1384e77aabe68ceda85a5864c76c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "538df448e1aabdaa570af8f7aa1f578960b1384e77aabe68ceda85a5864c76c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "876ae898ab0e3b8eab1ba6b98670e1ecba26242ad4fff2d5260b9a7887e08a07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d3c5280742365f2c67b2e3edb7cc3e4db750fd2a75ad0a0efa6f88882680bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa01614d54f0bf8d9a58b5fa0f46a117284c3e9c3a8ffda2f3dc6995884e3c3"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
