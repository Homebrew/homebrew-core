class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.8.2.tar.gz"
  sha256 "2f76b60302abaea7b2c8cd05e7a2c991c86b4667074434e3ff02dfaec02fc291"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24e86e5750d505030ad7945bd2e5bb671226b00c99f6e01f2087dbd3ba5b3612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd744f2f5610800a311ab24fa11d5aac4741a3b8e1fb3a25bce82df23a1009d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff24b3cddfce1fcadfdf9c3a1944a36480aa370aaa0b5fc321b33e6569eec836"
    sha256 cellar: :any_skip_relocation, monterey:       "201753dc1855391585baacd3c90602e8f3dbff0d842f6e92c6b41c8669fb1b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "18c00e468bcf45dca42ae4256edd74cecc911c94e000b74b48c242b6fabe9d27"
    sha256 cellar: :any_skip_relocation, catalina:       "1f15516b437d995315046c64f97b411b7f9a9d942e378257fed6140b75086211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077061ac114cceb32c558b5d2f58fd691bc9052615b0cb94e872b248a18a6a61"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
