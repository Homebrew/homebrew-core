class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://pvetui.org"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "3d87fcf9ffca7d25daac2c1ef7f6275633d2793925537f6893f350bf1b4f463a"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4170ed20a22ee3b275786bae3c4eab30b1c28bebaf416c9fa921ce851714d0b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4170ed20a22ee3b275786bae3c4eab30b1c28bebaf416c9fa921ce851714d0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4170ed20a22ee3b275786bae3c4eab30b1c28bebaf416c9fa921ce851714d0b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e94e6960dde66c4cb7f891d546ccf0536a5d60d7d346d63ac5f8e8b3c3197932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "258fd132f50ca9f53a50b13b0d20cea1de6259c63e2f448c543f60b7bfb8726c"
    sha256 cellar: :any,                 x86_64_linux:  "85d582a9290934c0d4ea16ae76ab1e7a9848226c3459577f2f31487ab461cfa6"
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
