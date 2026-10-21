class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.3.3.tar.gz"
  sha256 "6227811eb7eb8da2931f66b1d4fe52e664610a101246ca6340a66a02723bce5d"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "814e82a1ef3a6e357a41ecd8a6acc6271dfef5ca0cba5f389f69f5d8c63604bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d7e88fea22be9192c73746717aee4a8dc9315d62fa82fb50088f34439fdfb55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d8691d2c4b77907d472598b8b9ab7e755addcff37047b1a1d78b4b2f882fdbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99af97f26dd7fa18d5a43a629450886b49b3ddfb52899f48d618a9c0c4094872"
    sha256 cellar: :any,                 x86_64_linux:      "ce9533de4c89ef2bbfe68577dd2d7cfdf4db510afd4cb5b755e046175ea34fb1"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  deny_network_access!

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
    generate_completions_from_executable(bin/"ipinfo", shell_parameter_format: :cobra)
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
