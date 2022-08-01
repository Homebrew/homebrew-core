class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.0.tar.gz"
  sha256 "fdd90231ca0e502ccc09a57a2753ce79721703b9be12683be578b1947970a95b"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca440a0ce1d56b31c26e71f49b3bb60a0216065c8805644aeb0849f6e418d99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14cc7f90ec0aedb3185cdbc811a88732c0cbedf31b2e6f6863a718d4327b208e"
    sha256 cellar: :any_skip_relocation, monterey:       "ab53c917ec5c03ca988f939dc9e6efa3dfd9b27fdc77a5e89dfc8213382a50e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb3c08cada564c948326ff8a85d75bd128f05e4ce874023ac6626cf3c3384fad"
    sha256 cellar: :any_skip_relocation, catalina:       "48728ea70c61f69bfec17ec9e9fd3362840b5608fec324a438c5c708bf01db5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf7facaed83187368339d6c47c2352e8c6830095d936e8903e870f34c7ae93c"
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
