class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.243.0.tar.gz"
  sha256 "e9cbbb85fedf0dbd46118df0507a290c98c71f9aa7f093c3ca14d9e6d67fdf4d"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4252d9bb1092a50da3e4dd0fb199d5339e7ca75849d7e35672615872dc3da3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "024796214599351be82eee43187c3c21feed8863f224a4f0e5b46d690756d393"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a407785a743fbe954e14f872bd893112b2550884f36ed1136a7a755126dae753"
    sha256 cellar: :any_skip_relocation, sonoma:        "785f87dc686cb1ad15fe8e1b72251cc51a866afa49276bfbcffa3d637ea6acbb"
    sha256 cellar: :any_skip_relocation, ventura:       "dfaaca4ca8d456f72c441c1d9f8bd6e06235e98947135aec0702ad0a8024b27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd7251511fe155d104efc24f6bff7cc070bbfbd498ecdf7719ea4267e9cd3ddb"
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
