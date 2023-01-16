class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "c63d4388da5f51907dca3ad9410eaf742782f7dda3b9333e4d0196dbe68666df"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c6c5b7eb65c449bf1e51caf7ef247cd6c8b8702995f0a6faa9cf85667367d4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a09ccf8a2e8ee72a95992f174b060444898f2859bcce9af809f1ed1f6a7046d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2b68658b13ae394e674d02a399b84dbe395f98f7b8c85b11fea3856fdf2d555"
    sha256 cellar: :any_skip_relocation, ventura:        "b3ad12f1dc46a5fd23212a84e11c801931ed1efe597080945645aaba16a16b8a"
    sha256 cellar: :any_skip_relocation, monterey:       "260ff926a4936d30bdfcbeee4e390e4cff3d433452cf26a995e9a03c032d0fdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a358f8ba0754873f8024f74e66d3e77519d76967ee9a562569b078ca4ad7ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bdb16851e8b07de66d7125f3c53958828480017bfc699853971866b0b5011ce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Got permission denied while trying to connect to the Docker daemon"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
