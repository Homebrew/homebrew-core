class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.46.0.tar.gz"
  sha256 "9120908e8b7569008c9d67c37cbb31a0c2b64e2dba1fb2a1bc45f49df5698399"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "584a460fdcb2c0e621549b46ce6f4f54eb2ed400227fdc94cf1e42cc39daa86c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c3c1deeefe57628af52868a9e4ca6fa94416b6e6780f71c324275977045927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a91416f50c3cb9639344cdb0fd2c2b7a33b23b06c60aaaeaf58cb066ed42ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "f5011aec64ce2fa8b10ae068f1f06c392ac464226780a1571c0abc298fae1e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "cc1f20f257fda8dc8be62a61c04173fac3066a0dd961128e6e6ead7fbf5934f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f0b19cd569ab31ea43264de4fbb20eaf485053915cd82ddc63065b0b1404d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d7917cfcb9c2b155ac4f1de906e7ca96a830bb8d500cf1b02f585ef13640b5"
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
