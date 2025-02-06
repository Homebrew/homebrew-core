class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.221.0.tar.gz"
  sha256 "60b4b43a2266a897793e47db9b182e2d5eefc4d7068a54575d4adf147061a226"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c02e3d8ee3e0cc439eac5d9a46e7a65110f1eaadfb2751fbf0050feeb8c93c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fbca6280807c27513cdd85b7677637067b16b96cb32a493d34f1a160fe98908"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee90e4ed577b741c6915321d1b9a929c08155555e382f04864ef9b857b3f6461"
    sha256 cellar: :any_skip_relocation, sonoma:        "5352ec999d0764131c6ab4dc692e76639a16ebe1a0d1f75430d0653852190979"
    sha256 cellar: :any_skip_relocation, ventura:       "4a45b6a28b678d846d4dac226efd172ae69fa85f79c9108a9af708ced77399cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a24d614dd4b2098e47f0ccb53ebe087b5215c9b9415d12e1fd96baf57849a7e5"
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
