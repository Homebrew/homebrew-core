class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.22.3",
      revision: "fa974289417987623d8831cd915c313652c6372e"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16ff455391768f46b87b3dd99b4728af4ba57595f9bfce7231135899b6fc715c"
    sha256 cellar: :any_skip_relocation, big_sur:       "be60b97549e05e29a88a707dd70b2be9ad33d237e0ba934ae1beeeacf4101822"
    sha256 cellar: :any_skip_relocation, catalina:      "be81affc31ea7e805d349b2b79490f71635185327be2a2fb35face1a49d68529"
    sha256 cellar: :any_skip_relocation, mojave:        "37317f58ab1ee1ea6202646df143c663c83c19774d8e30fca40f621949856d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e43c44c10b20e1b68dddd0cf61039ad16a7da3e59e9775642deeb4336a5672cb"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", ".fake-codegen"
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
