class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.16.tar.gz"
  sha256 "c82d088e31e56458d9ddb6412e81d173c1eaf996b9b3029834b6026cd3c2124e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11c927b20bd93e4dd58d34a7cc998f45b7f5d514eeace196ba45b4f883108f06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee5aa9f1fb861e5f0e8b0d615d57f0bf822f98eff32cba5059e3c8a5f4a4dc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55e10297f813a6b7f0beedaa7ccc19fa51b1c098982f1fdcf6221bbeafcbc6f8"
    sha256 cellar: :any_skip_relocation, ventura:        "128dfcdff008b162f6957987c2689934c6085aad6e2a056553c297317a1b2fb0"
    sha256 cellar: :any_skip_relocation, monterey:       "5f796890ff5cc2d6762f3ceeb0718cae8702f270bd3bb2f4680774f558273b6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "45f18d0434065ffc5f707193abce9683e3697aebdacdb754c8cd41fc22df8eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f08caec0429d564b171301f7a5f61942002f8d460ac812d967a8866beb9862"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
