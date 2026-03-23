class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.65.tar.gz"
  sha256 "46420ce902f1a696f02061c3183566376ecc215252a41116f395e7566b530d3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e19668de03876347104af41279bb90ecd72c11a3e634effdb02a38d3d23b4848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e19668de03876347104af41279bb90ecd72c11a3e634effdb02a38d3d23b4848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19668de03876347104af41279bb90ecd72c11a3e634effdb02a38d3d23b4848"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe09b3a1e96d5c577d32633abb3001f4e404015dd9b162668fcb688867e2049b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cee77a4d72b5edd7ec264cfae83e34279bfacbc2ed68757e82db07e96274279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe96cb47dcb6597a12b7364f53ce881329a195f35775e97d276af74f42a8186"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
