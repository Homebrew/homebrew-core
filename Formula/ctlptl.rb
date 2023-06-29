class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.20.tar.gz"
  sha256 "9a53e048dbd14d754872caae5310eb2331cda2b72f0dd57711504ba2dd8c59d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2053aed68a26c4ccfe177239da0474dd1a954f8feaf98971cefafafab35e5bf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8233bb53777a9e85db595c929026d88213023fa473b45e280ef2b4d6c9ab02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc505f0f5afd88bbf42afba4e77700b3382e3faed71740cfbf792e69c42b426"
    sha256 cellar: :any_skip_relocation, ventura:        "96e8d6e6660b58774756d16fad556b2b79ec3e91343cc1e310f393522b9b2a77"
    sha256 cellar: :any_skip_relocation, monterey:       "2b31cd998b2a09bfe1b96bc7666dbdd8fd9fc26a979c5e28c98bcc5552991e36"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ee115f29f114287b6a24f20fba70c1a611e12ace3c9b4041333f8a0f9f13986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9cf3a556fcbb19371c39fb92c33dcc4a8c2b8cded3fcf66ea1cd5477f5b85b6"
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
