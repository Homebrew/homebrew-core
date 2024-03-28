class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.28.tar.gz"
  sha256 "7f973f10e7bf634c7fa0129619202e64f1ef2bdc5483ff1499270f782836520c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "427b7857c5a1e9f5900dbf089c0bf27283bbdd3e066456b73cb66d0b93cb4909"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f4871c6b36eaad0dced39e979231c9a04d7056a5c3dd9fdbba3f6c4aa78e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fcf349c485c63d3c875d90b9b7a7cd3784acb5663bd7bd7de959aa0e5ee6c6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b200f34eedc4623b2d269779d572a64a3191e23cb40e78bd9999caed7efcf0d3"
    sha256 cellar: :any_skip_relocation, ventura:        "f1694f936c5dbddda23f0dff4317956afd76d630e70d77ede2a5a1d379a8c9f6"
    sha256 cellar: :any_skip_relocation, monterey:       "d3927357b07395e94b5a895b17b5a796137257a436c291149e3128ef3c2bedb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec430025d727ccc5ffd11b9cf2fa5d879c778cd24838b9fa0b9061468edf528e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
