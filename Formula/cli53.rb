class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.22.tar.gz"
  sha256 "5acf576662cf8cb01ecbe027dfc3531e19bd03c1cd22425125e2a0a986273a7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb27aef03a8a1238d7d6daebc3b1a40569c3895b3ff94deb2cbf600b3001e4e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb27aef03a8a1238d7d6daebc3b1a40569c3895b3ff94deb2cbf600b3001e4e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb27aef03a8a1238d7d6daebc3b1a40569c3895b3ff94deb2cbf600b3001e4e9"
    sha256 cellar: :any_skip_relocation, ventura:        "0cbae4a4ed0e2f14e48ae285d665b9d683a4f3c23b74735992f4a6d77c5fe0de"
    sha256 cellar: :any_skip_relocation, monterey:       "0cbae4a4ed0e2f14e48ae285d665b9d683a4f3c23b74735992f4a6d77c5fe0de"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cbae4a4ed0e2f14e48ae285d665b9d683a4f3c23b74735992f4a6d77c5fe0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe47a8f80755ada1e60568573e4cf46bc61307892747d726ad9899b89f093ff5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
