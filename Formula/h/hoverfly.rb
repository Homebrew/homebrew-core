class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.12.tar.gz"
  sha256 "aed545a456346fd269f6f77611d08fb654a1b53ac927e8b290f155908f3f7af9"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1225066a20530302a494f374bc8b128cd81b440d19ae483dc9eec07b7845b273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1225066a20530302a494f374bc8b128cd81b440d19ae483dc9eec07b7845b273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1225066a20530302a494f374bc8b128cd81b440d19ae483dc9eec07b7845b273"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9f17c63c34f6ddd17954172c2bdcd6c069a98d25d93c5265f9f875664fda4f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66db3c522d634dcee7bd76d7ad7e11ec8c61b80a874766e6b269551c489fcb2"
    sha256 cellar: :any,                 x86_64_linux:  "2667c70c50bf5d34ef61b8fe2b49bacdb86f6a9f82d91a213c1de45b567c1f83"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
