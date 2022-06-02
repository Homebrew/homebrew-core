class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.18.tar.gz"
  sha256 "3590b0269b8316c498d122a03bf01ff9b18fee82fca524669061182b414d4f8c"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30058fffbd4bd4d9c44450ccbf72504e6e7902798fba4c21f060bec8562e44d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f49fa010c066a1dc535b91944fc985a6ffcf9ca7c25c282ed419dc8ff3ada5f3"
    sha256 cellar: :any_skip_relocation, monterey:       "46c1491236965a0e320b724e2532fc79a189431349372c74535f5fbbe9a62e89"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb26140f67e1d1da5636697d87bcef08cb3ae7975413f0ddd14379c194274fbf"
    sha256 cellar: :any_skip_relocation, catalina:       "d1947d48029eec0351e15d0fa618a0f14a6d12989976f6409ec94d294b807721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a8f7fc59f282398758bb137f0ee8631b2c1f4f4694d2d1a47919f1d66a72239"
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
