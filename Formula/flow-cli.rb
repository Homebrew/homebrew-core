class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.28.3.tar.gz"
  sha256 "58bbacee620fe0cd0a53c3dbd8fee6b36dbbcc876552291b9dc109314fa37740"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7065ee1fdbf6a485f4f6f8cad0d085b59b4106828cdf342605c4143180bbb1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b45fa75b7e3172179887e9f1e3531a4c62fc0bad81104ee264647a3d16202fcb"
    sha256 cellar: :any_skip_relocation, catalina:      "fcc81ea6b689f6e574d56b43167bb94491bc64605e38291ae605e1edad2996c4"
    sha256 cellar: :any_skip_relocation, mojave:        "ab1360c77c909e3952e33c1c62083ae7df639964cdaafa5ad4bb04810540de26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deda493010c94063da14e54251bb5842fd0e3cefee638bf24e0d0aa58931265f"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
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
