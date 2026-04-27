class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "37e1b8577427cfe64149aa234af48519dde5770f03c92f579ef76ae1fab838a4"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28d73a4ad7f59ec3d11febb6b592ac86fbec76a1954f9fbd19449bc412f4959a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621a59f72f34bb04b74538ff910eac0dc9f8eafc44c97aa2739776f3367c3e0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9795632f4bb65e882b06150168d579579262dfc0e7b199c35ddf4a3c8512249f"
    sha256 cellar: :any_skip_relocation, sonoma:        "998e8714054771ba73f891255dfe5ff32e9b4fe9248d3420c240d2c3a277fed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ebec1e9e7113e117aef8b8f95b8868f230a0c1b93d7f8eb2aee12b995444014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb413ed67a5af4d190d8fc80beb951a1ac4e74df5522a68acab876711333711d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
