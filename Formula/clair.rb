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
    sha256 cellar: :any_skip_relocation, big_sur:  "324ad2b7a26d5bb95edf88f23bc63cdf809305e7dbcef5f4625d226c7cc75511"
    sha256 cellar: :any_skip_relocation, catalina: "cdc0feb3362b7bfbcebc488bd885f0827dc112ab6b9a2fd5b0c7e32a713013ac"
    sha256 cellar: :any_skip_relocation, mojave:   "2b4d4802fd7321ab28d7fe7fe1952b9d4e2b7ea81dbb7e6faccd74da6804c643"
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
