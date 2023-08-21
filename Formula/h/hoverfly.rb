class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "534ca7b594b0a5e1313c479487233cbf8f5c9a3aae06991e2af84088495b92c5"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd72317748a9528ead8a9f3de5da842e52cf1f7827ff1d4e46e061c0e4d2f09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd72317748a9528ead8a9f3de5da842e52cf1f7827ff1d4e46e061c0e4d2f09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd72317748a9528ead8a9f3de5da842e52cf1f7827ff1d4e46e061c0e4d2f09"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9fc18f545f92fec77c4285739eb2b2b8e23518d8e2fd991c31a75c6151a3c2"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9fc18f545f92fec77c4285739eb2b2b8e23518d8e2fd991c31a75c6151a3c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b9fc18f545f92fec77c4285739eb2b2b8e23518d8e2fd991c31a75c6151a3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873fb82a7cab81e7cb4c6fa64649e4f95408a3dc640443614ada842a4cf332cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
