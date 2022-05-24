class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/v1.2.16.tar.gz"
  sha256 "6fbd2a77f1da05129fce5776202543e9a033729880d8b42f59a9694d3d773d8a"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "657e41b278ed88ca0e7b0ccdc423649367616665c48b3b4c114044a465abeb34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed8e05ae667449d37fa2e52f3c6f48de6715d2143d1d24b54fda5b79e33641e2"
    sha256 cellar: :any_skip_relocation, monterey:       "5b248c4883f161d49cfd3090b3a0d39164c23729d3f00fed41b4011f44893a03"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b9192101f04232a8482837cc51eb61b89d166dbc0e7a577f5fe7ce4c2fd84f7"
    sha256 cellar: :any_skip_relocation, catalina:       "75e8ede2335af91b02e42f2930cfadc0cbadcb23330b7560ae79e933b27df682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aae26215916fa02a7980a312bff9a00dec610998f9c178e56070b73d924f9fdd"
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
