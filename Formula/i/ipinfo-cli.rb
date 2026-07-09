class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.3.2.tar.gz"
  sha256 "ad5464068ec370599bd7624cd69f58047ac56d8140ba8e50b468c80e06c438a1"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd5a770f3763ffca3826152bd4e056eb2c60ae47219f36a33ec9f7c4b4d76a2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cafb083180fad88a5c117f36864d403227cc670e37937f5a2f2b3878e1de936"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b26ca6c5b4dee902726c4230ef72b9793a5b4994f273d589af0656ef1f51c6e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "20931465b2b3a1430bc224c892b8c82db6ab79c31adbd0e06cc3efde74ef6003"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2aacb42ea2ef2fff5efe7d481bd44964c277f474a0fa942da4ecbf1787a6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aff14e9acb1e9df4c3d44e1305751d2e472432e2d3739d157a562f2680d7aca"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

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
