class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://pvetui.org"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "e95beb9732002aff121934ea510ea07dde522b577c00663a96eb832b5d4015e6"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "711ce628a81e31e32017dd58007a81e3af2f8c23f230f40544f136348e94713e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "711ce628a81e31e32017dd58007a81e3af2f8c23f230f40544f136348e94713e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "711ce628a81e31e32017dd58007a81e3af2f8c23f230f40544f136348e94713e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cded1ccbe5a649ccb5400f18bf59f02acd9579883f781275bb42cec8fbfd436a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "495985afc7e55d53b630fe6eb3ef06050aabf682b58a0d4aee7c1fef69611f44"
    sha256 cellar: :any,                 x86_64_linux:  "3569146293dd9b23424f51ac6ee5d7b2af5257952740f20392759c0e386e0fe0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
