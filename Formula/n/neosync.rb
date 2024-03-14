class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.55.tar.gz"
  sha256 "8135cef22ebaa21794678422a4a0d15bf17498fe6633f940529953184f474780"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6db4e727e8ea243fa1f0e82cc13696220310a191f5f9109a9a014251b6ac65f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e4fd204c655b4f3caac8c3cf5e8c48c2769d1a3856376fec47ede886af4a995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cf3032b7963fd39e8fc2332ed476a72e203c6cd23a6a8b653ed35044867f59e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1264f8e6ea85496dbe494f91191055e0991d9378c9ad0fbeb199d1f3965434a"
    sha256 cellar: :any_skip_relocation, ventura:        "36d94b6b594b5fe9b5ed8aade609daf6a9846cf441473307939500cc2856b52b"
    sha256 cellar: :any_skip_relocation, monterey:       "771f7fed32ae7046759cdf130103362c57f9740d1c07f0b1b0dfc61f88d31351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044ba1c315fbe30526ebbdf53a926c5ce9669ab2a6cbd5955e64fe1f036e6d1e"
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
