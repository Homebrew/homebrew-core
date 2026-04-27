class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.282.0.tar.gz"
  sha256 "41662dc9c71beac0c5ea8453fb68bd5ed681347ccf2855f4fc40427beded0115"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93fd47f05209263c46f68ce2510820a8ee6ba6d4741d83d588699eaccac947e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a97e4a073a58e665718c14a45dbef0eb8b51a7e732441b0a9e08d5e7a5a9d21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb76282d137c16d32860b732cbad5b1f1f9d16d5a0aa44ae5b9f31b63de6fdfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2975b813427e4f0fc933cb58dc3aeb09900c6f34557ed994d87b039151cd8338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442ad67015896e71f41ae311e15d5b9f1478657c0f4273a830d41f2e72138278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a35d76ec67918529a80c607ec68fe936e709b062a79b08b3716f360769e9365"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
