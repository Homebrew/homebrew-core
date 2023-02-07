class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.23.tar.gz"
  sha256 "a98f06248336d18b24b8da80a2f289f52bdd58adc41c34f048350194ad7e7831"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f47fb46778239a3eda7a874a1466003abe53d67a686d8495da726a3dd39cb72d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e594bcc343d811d763979b981b1c7b8496c47443c2e22170246397db9b34de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed677ef76c182db0e0d3cdb9f88c29289f3dd530b600e94061bed6cbe9f69bd8"
    sha256 cellar: :any_skip_relocation, ventura:        "4dc2788d0bda39e91940bb237631aeda2537762f666906564e68ec045c60e7bb"
    sha256 cellar: :any_skip_relocation, monterey:       "67106e0cef59bc93b9e85df9793591653f4233972ea34b0a6e4625484fd56582"
    sha256 cellar: :any_skip_relocation, big_sur:        "deb92fd71928565413fc00c6e24a894a6414e98a58f62ac1af12f59d9509f0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dc7dba22cfc16dcc8bf5d8f40ac5871dbb478917630644c217b59cde79b8dac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[ -s -w -X main.Version=#{version}
                  -X main.BuildDate=#{time.iso8601} ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
