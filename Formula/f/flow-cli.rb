class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "3d6c84d67d76e1e68380919c4f6b27bfafa177cd22416da85c662d0da28fc229"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce87dfc848a82d6bd0f28a1ee4edd6ec03aadf31e6cfd72b33ee189ef505eb4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7aeb93a3191d556bc10574c1ae27694802e600306160638cb2a70296f0e430d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f29af52d7dd6003939e721d17be7f7b4a16298a01ee03b93fb9330fe6d0c5b39"
    sha256 cellar: :any_skip_relocation, sonoma:         "062698736b693c5fa6c6931f32265a48e7aea08571fd81317885158c016720c0"
    sha256 cellar: :any_skip_relocation, ventura:        "a2257ab9576a6b2679a321dc072a7685faee272184ef7d307874cac60df1c8d3"
    sha256 cellar: :any_skip_relocation, monterey:       "95307a2e2701ba0dd395f2204e1b3c3c6be121c03ebcce49c9f1ea16195d6080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae4164b6c5bce7668e76edeb8510251e3f04d3fc4fed16f4ac9fa74f637af94"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
