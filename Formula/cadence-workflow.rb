class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "05503975252702747d01fb2326a83174ed2672cdd0187cf7b38f42419e5b68bc"
  license "MIT"
  head "https://github.com/uber/cadence.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4108b02d4a11dba98b26af83c2633550d922eeb00160218458f9896244cc6b25"
    sha256 cellar: :any_skip_relocation, big_sur:       "04a9302cdc9bd7ac3986ba5dba8d786dda09737410071b5d33d59645369bb0fe"
    sha256 cellar: :any_skip_relocation, catalina:      "2402f801a03a4d4a5a557958e0f7342e70901c988475eaed26ac02e1f9e84fa8"
    sha256 cellar: :any_skip_relocation, mojave:        "5f123ab1904790aa0442ad18d3f9fc09ee99799711403e96e613964c3ad84ac3"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", "cadence", "cadence-server", "cadence-canary", "cadence-sql-tool", "cadence-cassandra-tool"
    bin.install "cadence"
    bin.install "cadence-server"
    bin.install "cadence-canary"
    bin.install "cadence-sql-tool"
    bin.install "cadence-cassandra-tool"

    (etc/"cadence").install "config", "schema"
  end

  test do
    output = shell_output("#{bin}/cadence-server start 2>&1", 1)
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
