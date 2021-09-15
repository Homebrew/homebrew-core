class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.2.2.tar.gz"
  sha256 "f2363014e47f68c2c0254121648a4ecca0baadcecfd1221bad3f52ab3d66f65b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "b5faebb8f68c655915947dba54810d42e190c6f5968daeebd2ddf4bbe0f6f578"
    sha256 cellar: :any_skip_relocation, catalina:     "a99136e4561adbdd70cb68270035ae49ef38ced0ad76c75e215b4c27e12f7df3"
    sha256 cellar: :any_skip_relocation, mojave:       "d6af1310160626469d81d9f14ee5c247bcb913f3c984210e444a2607a66d2bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b60e0f16d3c41891a652aa8eb4878d203153cbc6502791666c058ab9f21cf281"
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
