class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.5.tar.gz"
  sha256 "ec9ef8c7cff41d43b754859e4eba9c7aa2453100371c4bd01e82ac46dcf8f424"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07cde489c34a237411f64ec430fafdfaa096e006ad0fff7c504ae8ac10d9788b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2cbc2fcb81774b4ba7f82548d2e4f67e383ca06af6c308eaa0a463144159a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "8c4ed0ee5cd0708252cf6ea0fb0fad11d0fbcd6069fc1c8343d191cce40aa0ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "d029d03fce9096c163de85b9084d2c7a8eab195fb3895196680fc3d7c9948801"
    sha256 cellar: :any_skip_relocation, catalina:       "93bbe2f3b71611f35213a7c6c2ed2938156858931254c7b6356e6527412d3cc6"
    sha256 cellar: :any_skip_relocation, mojave:         "0ede7021872b98becd1eea302209b11cbc0198a7fb812517a4cbbe1d8325f0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "788f0f18ac38c7047441dd6db332a176e27aef39830d77b78c85e08b280db424"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
