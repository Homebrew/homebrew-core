class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.18.tar.gz"
  sha256 "3590b0269b8316c498d122a03bf01ff9b18fee82fca524669061182b414d4f8c"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ea7407383cef6e284f67f76737b9189b036bdefb62f732cf0f2e950f009b5b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "060099b9d37e893606b8a30712dcdf01d7a3695c763530d2e838fafeba11d163"
    sha256 cellar: :any_skip_relocation, monterey:       "4f2db796894aa6826002c25e25b4d2cb208975462ae048d709aa5c5f1361d52b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d72f2c355899234f2c79d470059d933a1dd4d2af32f22b7dec4c3bb64fa469cc"
    sha256 cellar: :any_skip_relocation, catalina:       "b278b24187c17c35b67d9f07697e29eb1aabac7d2d71374c7dda4ba57957518e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5263d50a1711fe2df7966c7489dcbbbef5f89837032e2dc57e5a800f5d7e10e6"
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
