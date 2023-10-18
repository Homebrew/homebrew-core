class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.26.tar.gz"
  sha256 "91e4d00563c760741aa730e210c4ce867a04d564267ca31d4ebe21af5dc1eb8d"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58278ae62283e56e7c15561d2e71de807ee738f41af7a8600cd6e29c76dad9dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22291992ba3b219972dfd29c8672b39fa6cb01abfaf16078dc9c7d97447fd675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20c0df4a662975724b6fe58659c44dae08f547d52531bc105f95db688c7ae77"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f7356c83f061ba935de40d894ad865b5921df5c50f51d08f4e6b31165277a6"
    sha256 cellar: :any_skip_relocation, ventura:        "decfe5504069580968c2b103dee91ad0236fb177623b5f062b3c3f250e2b6f78"
    sha256 cellar: :any_skip_relocation, monterey:       "42b80b7dfde1305728b448b427094835cae49f60b500dabbccb8a8168d36bd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04fc3b5a6c16ff977a53abfb5c6bb6002de430cb195b5c0c32033fdfb661788a"
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
