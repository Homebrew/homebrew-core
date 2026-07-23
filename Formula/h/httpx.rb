class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "3665354f4b090224c546e9ad0508d72375fb3885950b6aa8b34b8ca80db61ee2"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a809a1c98163a54b220af5e55875ab9bc93a0525f15e3ccc9fc46c959ce48404"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c22ce8a5115fc99be5c32580e56f8f3a18e2a949c79b3301606200081e9c38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50763b24b283d2df3b00158c98ec937556f0a9fe8dcc5a5b52165455c480c70d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d9ab800e00f52d91708f67e3919175dd72c4b668ee13c9310f2a58b17353db2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8760e6d918e870e699658c2e2b44a2a342e28bb961ec67cc7421a08b3ec7028"
    sha256 cellar: :any,                 x86_64_linux:  "a92e9e8ceab28b5af52d97072abee30e228545e807ccd4c596d0f7ca9dcfe1a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
