class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.3.4.tar.gz"
  sha256 "7f99980c1d0c3ba75339de75b2d5b7fb97eb8e7956d84d140871c6a3014885ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "27a14b2e739905d2f36d78c58535b86663eff94a2653952f8ced71cdfc3576d9"
    sha256 cellar: :any_skip_relocation, catalina:     "6970f36dc5308e22ee0195a627352e66854248f27aeb36f7752b34f6d9e78584"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "589597abb46193e407538104c0bf80b00e254076cfe2d5e62ebde0171b1eb0f3"
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
