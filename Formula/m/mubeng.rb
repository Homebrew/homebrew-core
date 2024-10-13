class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https://github.com/kitabisa/mubeng"
  url "https://github.com/kitabisa/mubeng/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3446bd114a1a6e0526c926fa264e3d738b3fa87bed1ad4f5e0899bb97ee12148"
  license "Apache-2.0"
  head "https://github.com/kitabisa/mubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ddc4f235a35b9b3140b09ca7e8c7729a48d9a5a37c9325b4b51aa9c7d1c5203"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ddc4f235a35b9b3140b09ca7e8c7729a48d9a5a37c9325b4b51aa9c7d1c5203"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ddc4f235a35b9b3140b09ca7e8c7729a48d9a5a37c9325b4b51aa9c7d1c5203"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a886da9f86fa1435f857dacb8392b0455b449ed6d79c66f9ce86aa3ff7dfce"
    sha256 cellar: :any_skip_relocation, ventura:       "94a886da9f86fa1435f857dacb8392b0455b449ed6d79c66f9ce86aa3ff7dfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55672a281ff4002168fd4f7dbf0d3e94cc374507e168b5365c6772df24ffbe3d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kitabisa/mubeng/common.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mubeng"
  end

  test do
    expected = OS.mac? ? "no proxy file provided" : "has no valid proxy URLs"
    assert_match expected, shell_output("#{bin}/mubeng 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/mubeng --version", 1)
  end
end
