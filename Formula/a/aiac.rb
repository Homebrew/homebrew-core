class Aiac < Formula
  desc "Artificial Intelligence Infrastructure-as-Code Generator"
  homepage "https://github.com/gofireflyio/aiac"
  url "https://github.com/gofireflyio/aiac/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "45e48cd8958d835b402e0e68d7aa8b9642deb535464dad5d6b83fb8f8ed3d79e"
  license "Apache-2.0"
  head "https://github.com/gofireflyio/aiac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd35116079cf1351dad53d6753863a5301638121559915331c21dcd2a8a10173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db2b9d958b304727cdaa0a7147908f4f01bdbe3ee2d43ade18426b9dfb6aeaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db2b9d958b304727cdaa0a7147908f4f01bdbe3ee2d43ade18426b9dfb6aeaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4db2b9d958b304727cdaa0a7147908f4f01bdbe3ee2d43ade18426b9dfb6aeaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dbaa7b25dc9be8356f083cd11c3e5d6738b8b0545cac4f4000196bb4d2bf39a"
    sha256 cellar: :any_skip_relocation, ventura:       "2dbaa7b25dc9be8356f083cd11c3e5d6738b8b0545cac4f4000196bb4d2bf39a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d5c8fd027682c85c921bfa1fad5d4bb2b4ed7fa4c75f14777ec8c043ac9911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e74cfb47682506cce9ef87848aa085274b067c36139d49cdbaee1ed9259c193"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gofireflyio/aiac/v#{version.major}/libaiac.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiac --version")
    assert_match "failed loading configuration", shell_output("#{bin}/aiac python print hello world 2>&1", 1)
  end
end
