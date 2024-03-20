class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.58.tar.gz"
  sha256 "5590fc395456e505463427467042274f0e61c7cf2eb1fdb30c3add3e47d42dcc"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91329f45e211da29223008e830e3c5741331a36141471698fb9793932cbfdf88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3707866d1a6f2e2fee1cdd7e1531636aef26a208343faa49924f1c7844680596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cde893e941f01038bb911c0df49cf01ff8cf527769c51ded492ebc1ab47f3a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "18d9ab8164ad2e95a2edbe5ea9bb258c47bf76247a4c6124b15c5e575a879b75"
    sha256 cellar: :any_skip_relocation, ventura:        "9c635b88bb80078941465f315f4a178a0565987879a2a2ce356c695b8aed6faf"
    sha256 cellar: :any_skip_relocation, monterey:       "d3bad1a17a39d0791bb113db258bcf498c9b371f8a6179a897b38b13c3175ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a58addf97c70f4c47f968307cad29243030c5a6ec366e1b30cdb15369e391b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
