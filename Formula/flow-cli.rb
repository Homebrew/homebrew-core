class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.28.4.tar.gz"
  sha256 "69d5f85e3e1a62c22384ad878c60ae6fd1a6c9449ee603f30b8a8e4b434f5249"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "366d252e7ed8620b706977c02538f7f3bee931265a18aa16eabeba7e0be7734c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7065ee1fdbf6a485f4f6f8cad0d085b59b4106828cdf342605c4143180bbb1a"
    sha256 cellar: :any_skip_relocation, monterey:       "96b0e0222cb752833f08f40df9329309c26283b42ec6a56f19639fefcfb3962b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b45fa75b7e3172179887e9f1e3531a4c62fc0bad81104ee264647a3d16202fcb"
    sha256 cellar: :any_skip_relocation, catalina:       "fcc81ea6b689f6e574d56b43167bb94491bc64605e38291ae605e1edad2996c4"
    sha256 cellar: :any_skip_relocation, mojave:         "ab1360c77c909e3952e33c1c62083ae7df639964cdaafa5ad4bb04810540de26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deda493010c94063da14e54251bb5842fd0e3cefee638bf24e0d0aa58931265f"
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
