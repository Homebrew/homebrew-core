class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.1.tar.gz"
  sha256 "02f2038f84f6dac399077070b2abc61b64de2425b92dfaef28400586419cc072"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2573c4e67d82aacf62b326d56ccf5aaf561ed258353629ef6166645a513e736a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "988699ae046a69865f0ad13087569a849909853c7250b74693816e252ae10517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5378627725364830e5ae105145e0a111d21ef00d9e44cec5eb51376df522afaa"
    sha256 cellar: :any_skip_relocation, ventura:        "24e0454c07cc9a79ac9ba96f1c6d4597326d80372ae851a62330d8c370b6c2b9"
    sha256 cellar: :any_skip_relocation, monterey:       "d46d3d91614956389a2a0d178bc9c19337057c9a5304c861f540adc64942a92d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3b98e08c49bf0492a0392bd88cbdc97d7825f67331536445808ffbc64a91e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ed6256e6befe43b24488f3746acb897a9c27a01058e74e2c89ec0ee51541bd6"
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
