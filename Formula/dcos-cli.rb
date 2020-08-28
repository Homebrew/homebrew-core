class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.2.0.tar.gz"
  sha256 "d75c4aae6571a7d3f5a2dad0331fe3adab05a79e2966c0715409d6a2be2c6105"
  license "Apache-2.0"
  head "https://github.com/dcos/dcos-cli.git"

  livecheck do
    url "https://github.com/dcos/dcos-cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f761361ad67f93ddb2e437ba807522ed6b6216f8bbc317d6eaa04981900019cd" => :catalina
    sha256 "6e93ffb09f31d29705faf1b2296cf4559514460e2231c23e871f43c1e87b569f" => :mojave
    sha256 "54d43e8f4b694bf552454fec21ca9aae5408416729d5d1c21be61108c7ddd1d9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"
    ENV["VERSION"] = version.to_s

    system "make", "darwin"
    bin.install "build/darwin/dcos"
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=#{version}", run_output
  end
end
