class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.16.tar.gz"
  sha256 "6fbd2a77f1da05129fce5776202543e9a033729880d8b42f59a9694d3d773d8a"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e79956b0c0611a473e56ddff7a089845ddf698f7ffdbba47a777e9ff923198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a1692d1971a555c1cee438bd4508ca325ffd9199a3002a3b6a76ec72b054014"
    sha256 cellar: :any_skip_relocation, monterey:       "388301df3ff6ff5ce852e725ee949fb594af9c1793175a18411e496901afdbd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f25a4a251725073bb35a6c2f579948993c0472fd9bc86759d1be2e00ff60a6fe"
    sha256 cellar: :any_skip_relocation, catalina:       "3971224a6bb7a3b20c498dba9afbb672f95aa1e04d7caa8628d502c743db8f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d34a0d448485badd5757ef8300f05f7e19bccbb1ab2bfcb1494bf9ec664beb59"
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
