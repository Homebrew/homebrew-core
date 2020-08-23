class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.0.0.tar.gz"
  sha256 "2169f72d23a5e4caceee3b863220bf6a4b4a15f7d88d5bb0de909ca4299a92df"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8551ee4ec39d50e8b596a5c7c3b4e8c62371f294937c951aae2f3e40931cb6d" => :catalina
    sha256 "e81b5780c4d24c413ad269c6d51ff226a5b7bf929003ced43200870604d01d92" => :mojave
    sha256 "c28c396193a02af6efadd816e5dea7d6a648dc178e8411e3a53885f44834619b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    assert_match "#{host}: no such host", shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
  end
end
