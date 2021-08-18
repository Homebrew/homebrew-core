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
    sha256 cellar: :any_skip_relocation, big_sur:      "5870dd1e7d4cbf50e68224703683bc81c15ac1b76ff41319eaf8deb99e48198a"
    sha256 cellar: :any_skip_relocation, catalina:     "376873953f5f3efd6b8a6fb62529133e9c89c53c2ec8a497a414d6ea60468479"
    sha256 cellar: :any_skip_relocation, mojave:       "ca582213b6881cc257326eaa78e93f129b5cb903e139880fbba696ec8ef97445"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "45f1fa5ae209f8205ca5bdfd0a10389d5d241150bebff53c2a7514c94e66a82c"
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
