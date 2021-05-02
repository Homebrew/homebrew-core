class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7d08b62b78c4c9d64d6e6c6c5e7874a0c0abad01369c378777d97c39c3d77c3a"
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

  # build patch, remove in next release
  patch do
    url "https://github.com/uber/cadence/commit/b6b70ffbced027f0833696aea09be350bd41d15e.patch?full_index=1"
    sha256 "1547ac2d655e8b8cebb3fb00431bf0e5ff6c0ed4100d2dbe16ee0afbb404e1cf"
  end

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
