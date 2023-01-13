class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.43.3.tar.gz"
  sha256 "a42449fbfc740fc8cd82e3ed025a8e98de0e128ca9353211d8def892b60ca146"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee31cf1a21e68c24a4577ca59565c5f687ea7fcb1da5e1aebc22cc3efa19a1fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f61cc4e2201892cb1af621c8ae449bc5aa6701f20f04be08dd0c2d077380a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e43dd5392c90127a54aa80950c29b654ada049eb8047e6372226b030c200c992"
    sha256 cellar: :any_skip_relocation, ventura:        "af428a86775f116d02e2cfdc8df330b45a5a7ef7079b62c6e26e0b7176dd771c"
    sha256 cellar: :any_skip_relocation, monterey:       "4841b1ee09b37fb301faf49c29358340dd4945e432da2df7ff025c092b1dd592"
    sha256 cellar: :any_skip_relocation, big_sur:        "305f37d1a3cefa763e7e13d3e5c52b784703a0c6a81a01b4c1022a6710e6a0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61f980a5c1a3a672faec4713772cc068064ca436216253dac56b936cef529eb"
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
