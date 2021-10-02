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
    sha256 cellar: :any_skip_relocation, big_sur:      "3d4a0ec7a32854f77acd4bf30481e38d7d95eeb629fe01542f505c2bbd92f464"
    sha256 cellar: :any_skip_relocation, catalina:     "5d0b4f8885fb38090a32f6f9b4d5f5b32b9b545ddfea2f690b8f92f595cbbd4e"
    sha256 cellar: :any_skip_relocation, mojave:       "6793c8d1f5379482ff305b1003e317995697772605087c2ec9c6557a2c6cef57"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2585e66a9e530b8e2cbfc00dd5a8daa016f42528795e2c31139314ef12c6dfb3"
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
