class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.28.tar.gz"
  sha256 "11f55b63a505a6c613aa3eeee4443908afd6f5f74b8e11438cd69cb4b60745d9"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "843c0aee4a251aae17d6b84a7b7aa839eb89fbfa37b74f647698b057722bb14b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bd5a7ce0331d6042a7f3924c33552d4ad16ae4bf51c8cf8bbbcc6a5505fe2ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a69f3195beb2009c2609cd6cfb873cd92be64becda0feb726f385598f9c061d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f8c793047d9e1607fe1d1395b5c85fbbb54443784ad663a9896462b4db8a9e5"
    sha256 cellar: :any_skip_relocation, ventura:        "c8c9a59eab5e9a5b1a747e92ba2c7fe8df400e5044601c9360aab1fa48507906"
    sha256 cellar: :any_skip_relocation, monterey:       "f00f54ae54ed019fe4eb3a1107913e2e7d4b4b565cda349311dd984c264ce266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b65b847fa84e6f9444a44c54b5ae91575776b3481d9fcd0774352e531639a5d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[ -s -w -X main.Version=#{version}
                  -X main.BuildDate=#{time.iso8601} ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
