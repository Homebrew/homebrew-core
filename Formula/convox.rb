class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.7.0.tar.gz"
  sha256 "fe6a58482b7071f4885f881a3f9674ac7c97017e249c48636fcb93971ad381ef"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f56ca0d626fde0663b7ad36501db6eda71f0da527426f599556a705e362d5efd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b2cd8f1774ac27f667883c11a98fe0dcb1282449ca801e8bf14659314facf44"
    sha256 cellar: :any_skip_relocation, monterey:       "094fd15ac9e8ba3b3be472c66f45ce307ab72806cb8542e8b0913c54b246e982"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee5493b375ac2736b8ee4ffe8e6e08f621e3104c63023d75e7b379f425f1c70e"
    sha256 cellar: :any_skip_relocation, catalina:       "05f0c405747fbdc22886d6bc863a7d58340c5465423f213159b695741b1538c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "609e3b7f5c61155a1536df03b6e177530a6d573e144a9b897c1e9dc65d9e74be"
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
