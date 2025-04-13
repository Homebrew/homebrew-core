class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "9a2587be03cab6622791a6bfa35af41203da2834531d7ddd9b020bce2c6c9577"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa0650cb2bca45af44b5c505b24cafa445131f788d3a881aad60d59dd04eeccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa0650cb2bca45af44b5c505b24cafa445131f788d3a881aad60d59dd04eeccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa0650cb2bca45af44b5c505b24cafa445131f788d3a881aad60d59dd04eeccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "aad40108122fec25a308fc098d7b7c58ff253a76cc272e0134f67fc6d0830dce"
    sha256 cellar: :any_skip_relocation, ventura:       "aad40108122fec25a308fc098d7b7c58ff253a76cc272e0134f67fc6d0830dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db976ddeba1a9c5a2ccacab93d9bfbf0ce4a92df1eba2b919e7673c86fed2399"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
