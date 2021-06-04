class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.0.5.tar.gz"
  sha256 "e6ce6ff418bb399ef41b56bd55057d24913ecd96a7039485e1b80cea5387baad"
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

  # revert back to config.yaml.sample
  # remove in next release
  resource "test_resource" do
    url "https://raw.githubusercontent.com/quay/clair/6e195c99a14139360c8d09f90c94024eb7d27b67/config.yaml.sample"
    sha256 "4efbe587cdc074d29cfa9fe539d97304a33c28fcaeb986d6c8e4db7f8c705812"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/clair"
    (etc/"clair").install resource("test_resource")
  end

  test do
    cp etc/"clair/config.yaml.sample", testpath
    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml.sample -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "initialized failed: failed to initialize libindex: failed to create ConnPool", output
  end
end
