class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https://github.com/mubeng/mubeng"
  url "https://github.com/mubeng/mubeng/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "533490d11563af3f30bcd892a594d4675f0e8555f4455d9c85899b27fb113847"
  license "Apache-2.0"
  head "https://github.com/mubeng/mubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4200b06232b9b251aa8d9c207d468bddc8f8d0331e7c177819e8fd29f9ac2b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4200b06232b9b251aa8d9c207d468bddc8f8d0331e7c177819e8fd29f9ac2b79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4200b06232b9b251aa8d9c207d468bddc8f8d0331e7c177819e8fd29f9ac2b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "89119546ada6f6603c2bf77025c65f626f21c3dd9f479aaa15d75f8cea701c6e"
    sha256 cellar: :any_skip_relocation, ventura:       "89119546ada6f6603c2bf77025c65f626f21c3dd9f479aaa15d75f8cea701c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4176e1bb53a2acf2a0b5fed9cbf243921f985d5a4ebb8725e4a405e668797e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mubeng/mubeng/common.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected = OS.mac? ? "no proxy file provided" : "has no valid proxy URLs"
    assert_match expected, shell_output("#{bin}/mubeng 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/mubeng --version", 1)
  end
end
