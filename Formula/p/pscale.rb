class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.270.0.tar.gz"
  sha256 "06ddb8eb6df1676768c341367b41b59d4b2f4ae077ca4343852bfd205269d31c"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f59b102c707fd62bbda52afaa6cd54bf1c0bbed1c4556552da8e00a7a22bd1d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9850ebd26dc1265580c3cda0388b1b397689880910f319d41d9de492c913730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f8b02d550ebb31265d734d0da73514ef06192ffad3dd99d534c7e9cbb33d918"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3b30ed9b075a4ab74da0f75f9ba4d882c39d357cec67706213075919acefdcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a47f2a6a1cd28d5a21c5ba92670cb1b0c98675cde518bec1f799dd0a8edec638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79e8c844ff09ddafe529b4a102062c6666443a7a7de67718184bd7c9cf1320e"
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
