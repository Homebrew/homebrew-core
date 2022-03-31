class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.33.0.tar.gz"
  sha256 "d3b3a761205f0c276496bff5f7b854f973f87370836fdfd591af5d8b82f2beb0"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7a8d4a3ca52aefcb5267b93d23b8a852e4d2ac02fdc0e02bd094a8a676d064b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8aa24283b0594c738c702dade23b62a055eb7aa6c0e6dedbbebde5dd4b0fd2f2"
    sha256 cellar: :any_skip_relocation, monterey:       "67881a6c5119d1873ad6fb700abffd94145fe629989e0076da5fbc2e1313c38d"
    sha256 cellar: :any_skip_relocation, big_sur:        "453d7182927aac3cf5de56e3a14dc0fab1d675878852f4c7b3c7abeeea7f48b7"
    sha256 cellar: :any_skip_relocation, catalina:       "7d059e9beb6eda94e7e50982f65bb85534b3839fb1eda43500717b16175d5ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ad76e7014ac98807f808b08a0d969f7f3ccee395e5d867f85c86141f1e60de"
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
