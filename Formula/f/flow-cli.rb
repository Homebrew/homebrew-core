class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "c73c9d1d0cb968e3de262fe7c60f28c86cedc47901977522b94716471997b716"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "041a7e2c0387a9a6f3ad36ce8217334d847f9202b058431cf466edbd07fbdd3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "113e0863cd3099b16620e0c55ea720f17350fe32646953dd9aefeefb92be5adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470fda1ee0b96f7a1ac83c8aa0fcbeb2a6088313b9e53fdf407082b6de3db4d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c27b7d269019d14e0d1fe6d2631588fdb48a0b2f5cc6597b884e5942eb1672d1"
    sha256 cellar: :any_skip_relocation, ventura:        "5dddadd61b948bb3b46334bc579f28fdf5e4ec3de649655a36c2f99363e1a242"
    sha256 cellar: :any_skip_relocation, monterey:       "924a932f5611f76dbc12bfb412e71308a3466744494967a5a4debbf0d3892a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "537598146f31e6adfd22f953ec5727814f5a83d50512b601c75813e956e37121"
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
