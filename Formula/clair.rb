class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.3.0.tar.gz"
  sha256 "56684ae29ce3fd2ad611978f459eaf232718bae1b8e584fba5830a44a2c103d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "64d39f7432c6753108c81d593294d14142a61e98a8fa8bcb173480a97b88e592"
    sha256 cellar: :any_skip_relocation, catalina:     "60c03d370fe34583680ec75c405c3ba770b3ce4efc3e71ee406569829a706618"
    sha256 cellar: :any_skip_relocation, mojave:       "37ec0796fbb2aa4adbda9a70c4fd3e59241fc4a29c2d7fd4efb7ff3f4f1265a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "947c6a051cc12db2362b1d41dea970ef176c9fede5bbd4803b52d88255439378"
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
