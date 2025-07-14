class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "8ba4a21d3b69d6543cd4445d4a7c4a05facb53bb9c3666400c11543b7c4a5bbf"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44aecd18a7d5aa28cb087bcb83072d1d02c4be22b7cf8e09a5de65b019a997c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b1d74ac9c887a5b51073e6c9fc848f7cacd3d57bedd750ce0746ed02b90b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9ae40632254cf4468eae608027a1878009d6fe8d792ce426ef0cefffe1033b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b32ebf9191cf0bc2191652f4ed515042ff4445ea3c74956d33521e3e211bb5f9"
    sha256 cellar: :any_skip_relocation, ventura:       "a85787447194b9e3c55c2e73df40febcff878d37b7f03454c6310fa9fe887a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4347078464fcb848c52126f27129f3baf780ed4c06f9ab4a8baf70a25bf38c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/simulot/immich-go/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}/immich-go --server http://localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}/immich-go --version")
  end
end
