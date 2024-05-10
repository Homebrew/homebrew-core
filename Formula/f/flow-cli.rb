class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "2681a86c5370f58fce74438155ba3a02b76e2bf0841c171b6fc93e819c5c9e55"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b13f48c13cfd65bf1fdb7294e9aae3b991d88fa991fe8c88562f2d0921e52ffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c87d6c6665ce45beaf7a27e26ecdce42aaa389932febfd0e12e243500a6e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c917d12b949c32c92bebd104e303587f2843fd5404c6e24b33c64037f7f4a328"
    sha256 cellar: :any_skip_relocation, sonoma:         "04454d14ccbcd6a631f30576fe54972a78a818a89b648ced47fe566332dd86a8"
    sha256 cellar: :any_skip_relocation, ventura:        "f44f56a7544ec24c3f1f07da69691297ae24bf4e224c64ffa65e5d170adcfdb5"
    sha256 cellar: :any_skip_relocation, monterey:       "804a7a821c71ffa5380ae348c951e43dc22ffd6bfd1767dee2686bcf1519730d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33dd871c88584a5eb95e6b7046e13b246dd2398b0ca1ee12100e2b5505d4acb5"
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
