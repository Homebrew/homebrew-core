class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/refs/tags/v5.8.15.tar.gz"
  sha256 "8d992c01e39201aa6b513030d2de81a7b17040a6881395189779bb3ab5f36bed"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7981c3185ddc4678970a2312a645c418822b99fcdc7103599607a4e661564a69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7981c3185ddc4678970a2312a645c418822b99fcdc7103599607a4e661564a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7981c3185ddc4678970a2312a645c418822b99fcdc7103599607a4e661564a69"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc035c4724437d837e4244ef64a637c18b3e6f2e805b14a3ab88bbd97de05a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "337079572e433500bb4d9c8da994a506c56b717b992c9fd366a9c37df2781879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb17950624747e7b7d8cad781c7a2785bbe7f19724185e6c08d7ac6b3d5b9a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
