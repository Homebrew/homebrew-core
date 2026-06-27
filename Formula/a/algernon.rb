class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.9.tar.gz"
  sha256 "4466f10bbbe278eb79dea571c040e16b154dacca83c736b7c3f8474f5e17f110"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82bf51039681cae7b732e91e05a90287f231e52bed1ea5f3bb2500fab4ef8901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82bf51039681cae7b732e91e05a90287f231e52bed1ea5f3bb2500fab4ef8901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82bf51039681cae7b732e91e05a90287f231e52bed1ea5f3bb2500fab4ef8901"
    sha256 cellar: :any_skip_relocation, sonoma:        "a637a28aadf3afe682c997dfc3672c0d980d7752c3185aa12631ada02ac6ce18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce1729ae56c53fb27a6dc95ce52a6944216a27adc533ed38ef64bac921b214d6"
    sha256 cellar: :any,                 x86_64_linux:  "f58b176d399d64ad4e2adb87fa0a75009a89a64c1ceefd2e92155efdaf030994"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = spawn bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db", "--addr", ":#{port}"
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
