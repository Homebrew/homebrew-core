class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.24.tar.gz"
  sha256 "1e5b612aa912bf756ee828f91d8d368cf886f56b61e9aa0cb3f5b9ca8975fe6e"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde965d1b1dd50d1ebae5a41734266ebb76aeb1ad49da5527c5d8e435ef30e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bde965d1b1dd50d1ebae5a41734266ebb76aeb1ad49da5527c5d8e435ef30e24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bde965d1b1dd50d1ebae5a41734266ebb76aeb1ad49da5527c5d8e435ef30e24"
    sha256 cellar: :any_skip_relocation, ventura:        "e6e10b92296a9e6acbb46bb79fb28a594266c5d7e86e65104e2b9a535ef15bdc"
    sha256 cellar: :any_skip_relocation, monterey:       "e6e10b92296a9e6acbb46bb79fb28a594266c5d7e86e65104e2b9a535ef15bdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e10b92296a9e6acbb46bb79fb28a594266c5d7e86e65104e2b9a535ef15bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518d50f123dc333bbcdde8443a6e42b32366a8f343081158a02362e342858ab4"
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
