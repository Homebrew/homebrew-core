class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.3.4.tar.gz"
  sha256 "1cb2eeec72224d527a78e787ab51639d2fcefb21915e10842e66ec4acb699148"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "997776d2a075b800bedadb7f30b11105d140b35da80a8f798ff7d61940d780e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ecfb071b20462f6047533b2ba3362eb149c429490c258969531f4d9aeae5465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e27c413463d04d20cc00a1292b13c7f556dae3d3c4c5d130e6cf9551b7586041"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01f803952e26050acae7b18aa6870884740cd4a2b586273a76f21110936dc754"
    sha256 cellar: :any,                 x86_64_linux:      "6138a40bee5081e696f17b0f9a73769b6f45d9b00b948021bfe6089e090e027f"
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
