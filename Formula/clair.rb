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
    sha256 cellar: :any_skip_relocation, big_sur:      "d99504489ca93bda1904b72c3555b1cb3a6b58333ec6e03acaa8d4731d749015"
    sha256 cellar: :any_skip_relocation, catalina:     "5cb2352a2ddb5ff3e5b3df2e9fa7d44850d0adcd2656a1e32d2597684445d4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a747bcec62817db7d8649a1cd6b2654e957d50a145de9b18f693da75e1a3f31"
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    cp etc/"clair/config.yaml.sample", testpath
    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml.sample -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end
