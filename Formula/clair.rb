class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.3.5.tar.gz"
  sha256 "e35144ea84d224e671fa4f634cf4a40109ae5dbab09491133b375d1558b2adbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "30d97ea6b8c76239c5e6fed844047f8d58ae21c4bdef8f8f6d09cf9cb2c301b6"
    sha256 cellar: :any_skip_relocation, catalina:     "724d4cdbb353b10809f3d8691034909b8e6535558f8d34ccee2b06d931d358f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6d0825918202d3c1d6fdf48fe6e3afa0ab4a29889cbc129c990e13ca4e800f52"
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
