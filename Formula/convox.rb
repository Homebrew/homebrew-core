class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.55.tar.gz"
  sha256 "30987ad4c853ab01d32391654a6f83664d5c34d50634d8e94c5c02b7e284283f"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89b647b318adef2119c5ba3b4b6ccdda1e733e497b5af3ed672d21082389e9ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "819b8ccc84ebc9ab001e20fde00fc197e5614cfe6ae799afab69291709d47e4f"
    sha256 cellar: :any_skip_relocation, catalina:      "86fa920440e05fa4663b2fe8e93597090d30003e29f281b1d83d1fb5e00fa727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36db56471c808028a43abdb2ee6b9fe6e4f4cb5fc7829b1a2fcd423c19962cdd"
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
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
