class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.0.0.tar.xz"
  sha256 "6120be57e66ccc526a39a5f7429bbb12b736270e86ffacc11a3bb97bf5c5a9b9"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47777efdac9e6d6f7f38515601853a453d112f40a0245f86dc36da469429fadb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "423da94581445d64764225d7ec525f0ad75b2002c86bb0c467352723bd94008c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8d30cc5bbfbfa4555303eaf232edc25da12086df1fb49b06c4d45da6e1023c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef8129d13e134649ec0909abf43910c81dc379506809c4f5ae921df97a832f1c"
    sha256 cellar: :any_skip_relocation, ventura:        "ce32c6c3cae369468b867a54efcd8db18b670f334fd42d868e9c762f295dd291"
    sha256 cellar: :any_skip_relocation, monterey:       "a81f55180bbbf02d2a282fd159f7aabab4a98c56a6279fb91ea559c28c5a44c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "901c10fbf9109c1666d5e60b63e389e3ce0ac30e26c9ba1bbf1bcf41e958f526"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
