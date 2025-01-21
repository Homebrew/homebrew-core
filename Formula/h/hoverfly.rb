class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.10.9.tar.gz"
  sha256 "e03bb5d2182ad2f724d7d2426ae0edcbac5e3ce5fc14d054c2dee0ec41007957"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c791a00762c16e8481a2a56c210ab2c5d06a9c1bd2b9b99a1948ce9f9548dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c791a00762c16e8481a2a56c210ab2c5d06a9c1bd2b9b99a1948ce9f9548dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30c791a00762c16e8481a2a56c210ab2c5d06a9c1bd2b9b99a1948ce9f9548dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "02786fef7555dcdeb3b2a9a93a6d4ad9d2a24cc5628751eaf0893ba0e2ea47a7"
    sha256 cellar: :any_skip_relocation, ventura:       "02786fef7555dcdeb3b2a9a93a6d4ad9d2a24cc5628751eaf0893ba0e2ea47a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c1ba19134776a9bdd5cf23cb621b4bf8ecfb9ae7bf6e51d88a5d8eacd63048"
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
