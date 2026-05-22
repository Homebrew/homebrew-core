class Faramesh < Formula
  desc "Governance plane for AI agents"
  homepage "https://faramesh.dev"
  url "https://github.com/faramesh/faramesh-core/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "e9b7ef902f87629990ac04e7df3a6580e5d4fdf4e3b157f223bf7ed4825d5065"
  license "MPL-2.0"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/faramesh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faramesh --version")
    shell_output("#{bin}/faramesh init --help")
    shell_output("#{bin}/faramesh apply --help")
  end
end
