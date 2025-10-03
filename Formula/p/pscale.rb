class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.258.0.tar.gz"
  sha256 "b926a14beb6294e5b21f118b52b29957749ef3c1def5f9372ae30e316af5571d"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d2bff5dc2bfb5c66d73fed092f404e7e93b16305eb7dc45c11bf8b34319d8e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2817570ca174d232ae999303afa2177edd738a8bef1f72eb7819662963984de3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64ad7b2680077aca993141b28e98976a19ad73079d9d8a15682f2c727778c5df"
    sha256 cellar: :any_skip_relocation, sonoma:        "08afedb6763408a2dfe40a391608653465fd6e1cb74280fd57e1232eec4503ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4eb53d460d0740147fe6fe3ed08ebbfc05a7fe37ae8b4573f857af58495165b"
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
