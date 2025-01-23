class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "8e60e68dd260e5ef01c796535b19b712749c45b887c0cb8033e5c5091f7921f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f462f836991c6e166732b8e85b25f30c6d31d9a8262be472fdbb89818beec67b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f462f836991c6e166732b8e85b25f30c6d31d9a8262be472fdbb89818beec67b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f462f836991c6e166732b8e85b25f30c6d31d9a8262be472fdbb89818beec67b"
    sha256 cellar: :any_skip_relocation, sonoma:        "890404e2e099a3a26f72aea1fe414a4776c6c3095f431437a0cd938502545f7c"
    sha256 cellar: :any_skip_relocation, ventura:       "890404e2e099a3a26f72aea1fe414a4776c6c3095f431437a0cd938502545f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34cfacc5355e0b595f57de98b151d7ecebca58c0fe330442d8d8b2b7a356fae1"
  end

  depends_on "go" => :build

  def install
    system "make", "operator-manifests"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/cyphernetes"

    generate_completions_from_executable(bin/"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}/cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d' 2>&1", 1)
    assert_match("Error creating provider:  failed to create config: invalid configuration", output)

    assert_match version.to_s, shell_output("#{bin}/cyphernetes version")
  end
end
