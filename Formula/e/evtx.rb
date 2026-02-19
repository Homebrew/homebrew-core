class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "ff852ba0d469acc77630db41f0d3c76bbc4fce01e037b07770da3b9a9472d73b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ad2a98dbb129359b978ee095ee6e9004cf723841d0b7001288e326d1e79f896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30add89f3974b06020b0ac73251a07f7bca36389f11786765ecff0758fd99fa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e0b8f9c26c5c60c21032e680e6dc0114f863db82af8b97ce092a78680de15c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e99b685ee246720c41d180c960085172b9bb9eba8300441e47e22b098dfb0f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9c6beb8eafb842fd973785b96d9f906a37107168aab459f82e44e8406c6d84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1121bd8b48bcbe67e5954045d7231f2cec10bb67d0ede6f15021214ff990ee01"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end
