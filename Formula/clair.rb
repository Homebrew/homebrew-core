class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.0.0.tar.gz"
  sha256 "a49228c581367a4048d2c6f7f8148ebb264457ad3a26065812b64e165395ad95"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0a67ddd722919a47f88db76cfa2f10d052d5a72dbb78819dd5d6841cbba1f552" => :big_sur
    sha256 "0d68ea1e0d988662effc3192756c8b5c35051641980d7853582b9af313c5cdda" => :catalina
    sha256 "65fef5fe64e988408e491d404ec8514526c550ea785f37bad807626e3e82714a" => :mojave
    sha256 "902c4992f09e044694e5cad96191e5df4f4e1e6dfb51b6a25122a25f0c9ad9a9" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  # revert back to config.yaml.sample
  # remove in next release
  resource "test_resource" do
    url "https://raw.githubusercontent.com/quay/clair/6e195c99a14139360c8d09f90c94024eb7d27b67/config.yaml.sample"
    sha256 "4efbe587cdc074d29cfa9fe539d97304a33c28fcaeb986d6c8e4db7f8c705812"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/clair"
    (etc/"clair").install resource("test_resource")
  end

  test do
    cp etc/"clair/config.yaml.sample", testpath
    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml.sample -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "initialized failed: failed to initialize libindex: failed to create ConnPool", output
  end
end
