class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.11.0.tar.gz"
  sha256 "25ff3324af3b7ac8a1af12969b59b8b0353e6e17cc7a896d9153d2d096289285"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca33f43bba38b6a2cef19ff6062bc45fceb3e4771e8b30e68214408300843b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "911146bc0a2527582fc328439110d7b240d90ee67b505a4707d23b45b5d5abe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0834f4c72d3ada11a7fbc3281e71c528144aa25849663c3dba2800311ab4a30a"
    sha256 cellar: :any_skip_relocation, ventura:        "fb5ddbb739a32d56243f3622621412c7923419a043343cbcdc36f8aaf9784ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "94f9b54b86b7519382076a8b90a43fa270e43ae00aa43b2877915100a8b58804"
    sha256 cellar: :any_skip_relocation, big_sur:        "07aa47906db4cbfad672e3f22c52eecfba5e6eadc4831e3d2bbc47f390c6a71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6418ce933d4be0fc54717959ed5a3d9b79bf6dec326c4945cbceaa2d0725a0ee"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
