class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.0.2.tar.gz"
  sha256 "fc785fa5da0f3e5ca3f709d562131bc944967f65a4bc1668565b37ae4f1d174b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ef2b263b1d82682e1d20e611c9216fb014a5f11e4ebde6b0bc2608372a2f82be"
    sha256 cellar: :any_skip_relocation, catalina: "79cccc1868eb31fba3290232cba9d55002173f1f900bb0e8c1c387ac408cff92"
    sha256 cellar: :any_skip_relocation, mojave:   "47331fbe4a07ae10237ffaca80ecd187605d0b268c761149876bee5809fed3c0"
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
