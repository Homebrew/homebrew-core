class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "857906d2ce536f4ac0fda13ce0ec94cf7cc420de4006be0bc451e90cc7eb5ef4"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94b164094211e6e781303caf9002f7dc1e44a7b1f2ecc0ca51edd3308a3651f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70b1ec1ef8ea73cf891921ec5aa82be9c8b73ec4ef9a14dc5f435f532db9c712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89758f2c2645439e57d8c6f5d3f3fe0c73ca08f92e948dc4472df9d6bd694877"
    sha256 cellar: :any_skip_relocation, sonoma:         "77e4e6a4db47ca58e399e1beb74306e6cc40269ed63c1d7703ebf8a54878fbf7"
    sha256 cellar: :any_skip_relocation, ventura:        "d1126d46827d202190be85ce1da9e35a97731644b27f571843fa4e1f48beca20"
    sha256 cellar: :any_skip_relocation, monterey:       "a4b19b606d169209412ab1834169cd6270242faf4462cd6747fbfd5486e9946e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd75c13d231193cbbc1a39523d09df2963de8599f6bd0cea96a7e463622cd40"
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
