class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "e0e1dd419c836255c2db30739c3ed1cd340275d34a896bbcb6f8627aec6dcca0"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47652805fa532c0a702cfbde2feff2b2e0dc5bd6c809f537b8fc36df1861a187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47652805fa532c0a702cfbde2feff2b2e0dc5bd6c809f537b8fc36df1861a187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47652805fa532c0a702cfbde2feff2b2e0dc5bd6c809f537b8fc36df1861a187"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1fd286082d44520ccdc595effbd3c69edd42d720c9776bb29d03464f87e9bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39251be25aae978550659aee78a1a09af362ca02f1f9879e53d83e9af6e566a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6219887f3bcaa15dc151ae087d819fd16e091266142e6d662316803f3738f8c8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
    tags = "goolm,stdjson"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/picoclaw"
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")

    system bin/"picoclaw", "onboard"
    assert_path_exists testpath/".picoclaw/config.json"
    assert_path_exists testpath/".picoclaw/workspace/AGENT.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end
