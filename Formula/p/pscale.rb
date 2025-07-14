class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.247.0.tar.gz"
  sha256 "51035f2c57827858ad3e976b9c7f0eb8d96fa998b2bfd21ea5dc02b20d629224"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e336248e2ebb913f5ce928b997dbc7fe34ce225db2818d159e559a4808ff91a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d4ae839fa1644041bc8669a82921763ea7fe1c392d44abe78e10fe6bcc35d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5062e05dd60d63655e34f47b99f73be1a0abd922343ee26bb6b2febf3b5ae0f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "221079eacd12cf8ed53f9d59c7651452f3d827ec8c402a3956fb681a55a9b148"
    sha256 cellar: :any_skip_relocation, ventura:       "5a84ec40f720c2333d6abf669daaca5f71dcc7e2b05e6a2ed14ba2de6cb2de77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb6e8f82a409eca43d5b8ab1b83c1b36a841c1f8fdaadd298475fbde952c34b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
