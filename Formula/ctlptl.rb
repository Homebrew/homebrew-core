class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.14.tar.gz"
  sha256 "b4bf725e9d426ec47eaa27c892739c8af6e427313608db6a966635e920ef600d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95abf5eee358279a2c35d5792410861c367b0baeed57ac42cb94c8ae3e2360a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131525249bd750556dd3d318cfa04b08305081633502db6b43148ed561089bc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab89cc24d9375dfd1030397509815aafbd1066295c5a9d681776e6feba8b1b0b"
    sha256 cellar: :any_skip_relocation, ventura:        "e0700f3fa2bcf70cf1628179b0b475b543f769c33ae8024bf65d5a18a11370ed"
    sha256 cellar: :any_skip_relocation, monterey:       "e52561ef89cf93523549cbd0806dd639150a0e76562d714a8960b6f21dbbe609"
    sha256 cellar: :any_skip_relocation, big_sur:        "02df8ea213d946626aa4a3e0f8c0ced12986a1b53240862f982a9651947f50d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d36443891ad3d4aab54845dcdd315b527864c2a5b9c83607ee2751982d56deeb"
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
