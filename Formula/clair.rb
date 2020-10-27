class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v2.1.6.tar.gz"
  sha256 "51e3c1e13c7670406097b447d385cdac9a0509e6bcb71bf89c29d6143ed4f464"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d68ea1e0d988662effc3192756c8b5c35051641980d7853582b9af313c5cdda" => :catalina
    sha256 "65fef5fe64e988408e491d404ec8514526c550ea785f37bad807626e3e82714a" => :mojave
    sha256 "902c4992f09e044694e5cad96191e5df4f4e1e6dfb51b6a25122a25f0c9ad9a9" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  def install
    system "go", "build", *std_go_args, "./cmd/clair"
    (etc/"clair").install "config.example.yaml" => "config.yaml"
  end

  test do
    cp etc/"clair/config.yaml", testpath
    output = shell_output("#{bin}/clair -config=config.yaml", 1)
    # requires a Postgres database
    assert_match "pgsql: could not open database", output
  end
end
