class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.18.0.tar.gz"
  sha256 "83595efbf8bc672f1861982b4b25b90a94c4c1ca618d6100219743e26904d491"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ce39de949dd75a5e2b982d1b034bc777f95a1a2aea1c59f7c0e8a305e7990b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "728d2a217f6acc1f40d59f4beabbbfac99912ab1b3ee73f8285a40ab5ad0e29d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9573f262f59b589c60045b3d9abcc9ff973faf7ffc25029f185dc8f5312d67e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "144114851b55047d9859e64455e6067f1037328b03e4e56e2b469a52a188ca17"
    sha256 cellar: :any_skip_relocation, ventura:        "43a8d965b22c85d2ddcc691f99473415695eba6146ca9ded40e39735911d91b2"
    sha256 cellar: :any_skip_relocation, monterey:       "3804d7a3a71cb369d549d49aed15b53c8491feb69a26a3bc2d6d80ef3a8cadf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb35a117641696891139fcc4a3caec7a2a106e580d79154d2693529e8e35114"
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
