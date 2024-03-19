class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/refs/tags/0.24.5.tar.gz"
  sha256 "5f07bb7832200e56551e49b7c812fc107b3718468036c9fb1ba1db57c57869d4"
  license "BSD-3-Clause"
  head "https://github.com/immortal/immortal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abd24f840121f022fe89d409a00e5b47c943fe9baa1ecae3268b54f63fbb3827"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0bd1667b7385bc20b7c1b2590248f6431dcd129bcdfd8dc2311775ddbc4e94e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe5963c725ffa56c85a968228db14c13ade71032132cc850a605400ea28d09d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc6af8a28056e344789332ebebb4cb59b1836869f24e11962a38ee6de926e51"
    sha256 cellar: :any_skip_relocation, ventura:        "f3588f52a1349fd2e6e625c1495a1a73bd06170496efa3712e17147c25603a99"
    sha256 cellar: :any_skip_relocation, monterey:       "d31e1c6e65c7e1967d82446159267b473c0ca0e30a816861046e5bb89052b993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba2d3e2c6a8a4d5c53b9eb6a606732403ba0fff5d1e4493724ef0d34863573b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    %w[immortal immortalctl immortaldir].each do |file|
      system "go", "build", *std_go_args(ldflags:, output: bin/file), "cmd/#{file}/main.go"
    end
    man8.install Dir["man/*.8"]
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
