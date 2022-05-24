class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.3.6.tar.gz"
  sha256 "6a696c53be08d3ca72b5a4226ff2c2dec6fc39eddcb17732ec1d55d32d753b42"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ddab9e519446d33ef4d3d66b2bd39f1a955e49ce53b9c97ea4695bde1a8523ef"
    sha256 cellar: :any_skip_relocation, catalina:     "3d3ef8f64fcbe6f1f6f46b6b8fb499226c07ad99c62beb379c39ce682cbe7c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "692efc752906a3cf3df1ad8136a38240544edb3d787256046e981628ace96bd3"
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    cp etc/"clair/config.yaml.sample", testpath
    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml.sample -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end
