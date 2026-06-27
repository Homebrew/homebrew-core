class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.91.tar.gz"
  sha256 "16563545b1563792e4d09013ff12204eac8e97125a2f143155d6383d04fb859b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d73affdff7fc18f3975f32b0091a02e9522b87f409a031531b4f3b8141aa34c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d73affdff7fc18f3975f32b0091a02e9522b87f409a031531b4f3b8141aa34c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d73affdff7fc18f3975f32b0091a02e9522b87f409a031531b4f3b8141aa34c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "75a305888c97b9542dc2ba6c2fa37f51bffd07e94a822115e352d25db93427e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b297ba6e7b63aca9873686a3fade209edad1d993e838a7b2db49a88c4fcfb28"
    sha256 cellar: :any,                 x86_64_linux:  "f3fad13cc8ec1d16360b39fc065e85e256ca0e36f8406ef316471cf4df702d21"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
