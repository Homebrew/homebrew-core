class Hyperlocalise < Formula
  desc "High-performance localization CLI for modern development workflows"
  homepage "https://github.com/quiet-circles/hyperlocalise"
  url "https://github.com/quiet-circles/hyperlocalise/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c8d4eaffcd27511dcf41515ce32687e13c55219dd8246efa935a043a1d03bec1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"hyperlocalise", "completion")
  end

  test do
    output = shell_output("#{bin}/hyperlocalise init")
    assert_match "wrote i18n.jsonc", output
    assert_match "\"source\": \"en-US\"", (testpath/"i18n.jsonc").read
  end
end
