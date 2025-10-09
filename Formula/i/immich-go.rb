class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "e266cecf38cbdcf916918241882f34ed75eb23cc6dad6c5052103e6769e3dc27"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d7e8fbf5e01ca3bf1389e0f157c13f9b527fcbf607879b8811a48dcae20e577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84ec970d08d0394590367cd4893e304e86a77b1cd6b58c5f7503243b993acd66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d042b2e1eeb4e162af1f0c63eca8fea1ed48807b8609a3208950ece1a7499e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "387345df6575b7fb799800152804d4eb3d89f25999887c287d9ed834ec3b62b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26509656bd28b78d520cfbac6bc3aee8fef65332f17ded03ff281ae0db1c0fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c552751b9b4abdf821ae246f2495e258a24c142a1804c8ff81b23236479de20"
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
