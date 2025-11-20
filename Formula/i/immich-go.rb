class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "7d8762bef1514bd31a485b2420d2d4b766faa5c882a52a50414666eeb745938d"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f7127ddf36011b4e843e4b3c436fce002a1f638f1b025183c2480126bb63646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f7127ddf36011b4e843e4b3c436fce002a1f638f1b025183c2480126bb63646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f7127ddf36011b4e843e4b3c436fce002a1f638f1b025183c2480126bb63646"
    sha256 cellar: :any_skip_relocation, sonoma:        "20bb1574f04dff9348f3ff59a46bba730771fbe8924e8270bcc385412edda427"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ff596ae184fe578e53e9f9b5567b159812584d08d02600352aafa4297ee5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77f7a5a4fe77d0df102100f9bc3df0248175bb82a06d50daade73782601f5ce6"
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
