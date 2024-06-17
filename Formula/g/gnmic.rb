class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "37fa3e0cc0a9899508fe84dfd849d83bd28bcb23d8705c6a23a4f4fa6080f1e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c460520c7798190c67aa416fd81e36db3fcba13ae1d40f571f393e1309b9547c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c91b536f0b8d8351df6e48919783da24bc21244ac305902fc38327b240415c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "529c022886492396c2d9dbfacded6e8f3179d5376c892dd8790da615f2265098"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ba3e6bb13e3a757281c033051b00f42e67ccff1b7cd424f56abaa66306489a7"
    sha256 cellar: :any_skip_relocation, ventura:        "7ad238744873458b569ce34095c86107c0c2056faf21f6a95cac8a06ab7e359f"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8ec26421f489dcd4be2b4d59bf71b61a501b60c20b5ab77b72eda0d7cd0bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7159c83578aa3a910d7e94b4d3183f81ad5296a25f3be279e63f22a3775d4d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openconfig/gnmic/pkg/app.version=#{version}
      -X github.com/openconfig/gnmic/pkg/app.commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/app.date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/app.gitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gnmic", "completion")
  end

  test do
    connection_output = shell_output(bin/"gnmic -u gnmi -p dummy --skip-verify --timeout 1s -a 127.0.0.1:0 " \
                                         "capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed: failed to create a gRPC client for " \
                 "target \"127.0.0.1:0\" : 127.0.0.1:0: context deadline exceeded", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
