class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "9f3477e3e41c7f1aeca67471c9687594ea5c2876e637ea6010809e79a67f303d"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb42e0592ac410011d3e6059502642334ab3b0a35098644c67545daa61087ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ac170511a1f50804e3d3b7dbba24918ab227cb315e071b6ab98ad5b68e6a4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd72ab7af2f1b12c4d1c07a5320d3619b98ea890d00398782ba257b88a4194ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "e440a58dd8f1e48f1f4104d88a3d3cbba141d675fbec245b816181d022012701"
    sha256 cellar: :any_skip_relocation, ventura:        "4d9e60d218effdd8de450201460d2eec855a9159a63ff8188027ccc3e40d1941"
    sha256 cellar: :any_skip_relocation, monterey:       "dfdbf9a031cfb4b3d9e2e0c79996cdcdc9250062b0675da3c2e38c2dec1f1ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110c091300bb98f93001dfde4d1c9a18c2414dddc99247119f94065f05457371"
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
