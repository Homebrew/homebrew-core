class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "686924f370955b15e37534191acca3746b8b8b0834cfeae13ff0bf847c84201a"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c1b0a7f31203e02d1c0f5fa34a2ad610571b202ec7ef197589b418e483d25a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96561ab085839a72e775414d305f702dd3254a79b10c3ac20c79cf44fca53413"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d9a31d7be5dfc35a8cacfb0ff854d4176b27de4c07316b0eea78307fab31ef3"
    sha256 cellar: :any_skip_relocation, sonoma:         "734e4176c6d3a225dbdcdc34442276cedade733905909eda9c443f08d884e2dc"
    sha256 cellar: :any_skip_relocation, ventura:        "eb3b93b45eabc305f1317807fcb70991973950a3f253b20965c207b999526794"
    sha256 cellar: :any_skip_relocation, monterey:       "d4ecdafe0e8431f5efaff74186c28a65315faba96f159662c80ed6e96aad5092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6298e752dd5c5dd54acbc5f8a51c2c802d2bba4cfce515a13119d81a5d944ba"
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
