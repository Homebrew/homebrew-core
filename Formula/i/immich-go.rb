class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "b24fd12f28d9691853cae1f48ff846b33794a36a4d356912060d019314789fd4"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cd369ad88194accffa3aaa3b0d3c269daf665470cab90169b9e4f087e9b8354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd369ad88194accffa3aaa3b0d3c269daf665470cab90169b9e4f087e9b8354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cd369ad88194accffa3aaa3b0d3c269daf665470cab90169b9e4f087e9b8354"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1e766326a4a04710cf92ae2272fe40d0a512c56af09551a75efa8bd6afd13b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d4ace8aebe26da57ac040fb5d668d9ce20168cabe57b60703ec490e33730acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00db9a4e128716bb2d8eb4d0aa8acb5da9d57c95a0900b6c1cfb21b1ddb9ac48"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/simulot/immich-go/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"immich-go", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/immich-go --server http://localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}/immich-go --version")
  end
end
