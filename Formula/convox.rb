class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.3.1.tar.gz"
  sha256 "3f79ab0b75a20076391cc8fb144c7f43373940a9092fcafd3efac5be8c18c2fc"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776694f727daad87bee63b66e1c3443260d3a463122cd2ff0ce6d3c08d39881f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25b3d2fa15c549453377d2e8b2194bc333c189584af4e96a9f253301704d5f97"
    sha256 cellar: :any_skip_relocation, monterey:       "7ae8f6ff97a6109ec56d07469277313b8bded39c0607c3d2e6b7cd11c2d694cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "02137ae429f78e826f781576a9f417b04529f6f79fddb229644bafdc0321546b"
    sha256 cellar: :any_skip_relocation, catalina:       "fb8831cc31fc9f0f0b5bcea9399a214fa2b089223350d3980ed2c0a15e208207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b1b307bebc92403b7c35eccd954b1acfac258aa5a19191613d79a2e33b668b"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
