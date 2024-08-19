class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.18.9.tar.gz"
  sha256 "b0df98f459048249fead501e401bb6d67ee078b2e35c31d59f5a325db0e56907"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "698810f0daa566aa42d35e9ff576e5b66ccd5fec7f9bc3577a0017dbef3fb3e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07111c75ca69dee2163cc4447d6858d92b08b437a942d95407535fc10b6a8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c95a7f5d1b73177d006bde0a78e54f86ff91de56665fd358290096bcce67ee8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "69ca687335f6becff214d5f2f23aa44b346d2735cbd2ea533662b0ecc0a38548"
    sha256 cellar: :any_skip_relocation, ventura:        "d957a5066f29dc166feb7454009dc1932dd666908bb46baf6bf972c9539a0c04"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4b72b6c94ae37f8a4e5af5edf8e3ff5099f50371df4e138ce3319a12fe9f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab1a2806bf7c34e135c13fe14163dc9d5540e94278f68117564f2a74bde1e1b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
