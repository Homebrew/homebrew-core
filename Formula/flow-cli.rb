class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.45.3.tar.gz"
  sha256 "b44d6305ea9d85894f56942d758abb13e81244a9c219fb8733910b1cedf70f93"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "712cd9033ac3fa97b2b21b6aea76b28df337ef91bb1f34a1a5c220bb537107ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1033b96f462c4164221167e3c2833ff3c8e058fe7a61913d08c03df0e87fae15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c26ad56718539ba555af31b5bab9b26c7a4a1b85d16ff0bed0ad4ab95611a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "12f2f9c514d33965c8edb4c5adc9958b156877fbc817ca1e9a56d7c1dc94f1d2"
    sha256 cellar: :any_skip_relocation, monterey:       "705670c9073ea67185cc194f3bceb8aae92b61fd49de66c4b1833f0ea315dc9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f26f0c02fb386088103c5ada69b2c0c96de9879765f6ea3ef4e91e40bf57f40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d74f2f9bc8ae902e1ec9932f5ca669a3b5e8d8443ffda2548886ccb8d445aa0"
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
