class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.21.tar.gz"
  sha256 "df195d67b3a60474ee8a75b31532e69ce12e9a2badf74f85246021a589848314"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2d0c0a418e1cd0ff017fd03653224df97e2e29c643fe68463d6d83e96f16b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f11600dc1d0eded4dbaba06a6398131146feff138e75f825b0a07d8c13df6fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df77550a76790b8fbd22bd9548dd5f7e2ad2b2773a48f06eac48b4ecf7adcf42"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8717b3d731f2582a0abbec7ecdfff7de7e34a724c1a81806e899e14f62b650"
    sha256 cellar: :any_skip_relocation, monterey:       "7607cfb90a5882578223481c796aa8a56aaddd40dc63b674b75b80a992ec3461"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9955d91c8d180c100a0532e58f67a232c4bac9d468ae2d966da83cdb3cc415d"
    sha256 cellar: :any_skip_relocation, catalina:       "44363015d10035ae1e99d06595506f0c3f9e01c68d1b888fe5b6f8667e642876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5f477c3e76f220ab97c76be9e316c7a43a5f79c3b65720295e97f5a2acd831"
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
