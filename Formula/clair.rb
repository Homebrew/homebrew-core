class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.1.2.tar.gz"
  sha256 "5c0cdec2bc52725a06e7307a5783e6d58ac3389a377bcb1db22ab813378d4477"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "29e36d4081f4180e7c5ca4e33505f402be46697c42110caaf71202aae6c9ebbc"
    sha256 cellar: :any_skip_relocation, catalina:     "9c77e26cbab0a0196407025429f9fdc144be1534e1f7c4e7325a101f46a2b1a4"
    sha256 cellar: :any_skip_relocation, mojave:       "6e0ec2cc483e43dd1ad928554b72f4b9a4a1d84413f45c84615d810143baf70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1e3eb62ba2b35c7fae234678b612149229ae621026aa0328df37a44fa86370f6"
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
