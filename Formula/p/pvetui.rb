class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://pvetui.org"
  url "https://github.com/devnullvoid/pvetui/releases/download/v1.4.3/pvetui_1.4.3_source.tar.gz"
  sha256 "e87faf257cee413ee973f183010aa7fe588e8c3e7cb6f7e097504c5ef7a4120c"
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
