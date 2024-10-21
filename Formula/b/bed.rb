class Bed < Formula
  desc "Binary editor written in Go"
  homepage "https://github.com/itchyny/bed"
  url "https://github.com/itchyny/bed/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "dea9265b5a78e91851059c1c726ac40490825f107f8db6ae7db67965b92599c3"
  license "MIT"
  head "https://github.com/itchyny/bed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70be9ac18596e2cf7227ed3af58184f21e82e06a78ae69488b25d744cd4ae80d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70be9ac18596e2cf7227ed3af58184f21e82e06a78ae69488b25d744cd4ae80d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70be9ac18596e2cf7227ed3af58184f21e82e06a78ae69488b25d744cd4ae80d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1caa69d4199395f000ddc54c77ac7ddd010fc7550c00416a28e3e226f9d646de"
    sha256 cellar: :any_skip_relocation, ventura:       "1caa69d4199395f000ddc54c77ac7ddd010fc7550c00416a28e3e226f9d646de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dde45e54c61af4c574016a87eb755d9f8288664a4ec6824eeac75520a9634cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.revision=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bed"
  end

  test do
    # bed is a TUI application
    assert_match version.to_s, shell_output("#{bin}/bed -version")
  end
end
