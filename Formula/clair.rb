class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.1.1.tar.gz"
  sha256 "ce08ef2a07c96278b4bbe37ca493697e5618d9715c2ee3a310d01cd8253644b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "06adb6658fcb4d5d936edbe9dda9a0f3f3cc138a7af5a45764442bc8bd253d30"
    sha256 cellar: :any_skip_relocation, catalina: "64093c8898d8f042f9953e3a28616ce802b03ea66a6001dcf7ee04d08bc137fa"
    sha256 cellar: :any_skip_relocation, mojave:   "4130ba98783424e5a0c6cec2c2de0765ebfb2a7c49a985099ef7c34012c53594"
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
