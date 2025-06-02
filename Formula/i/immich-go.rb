class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "092d895a5742a97519f5e16bc926bfcf5ac173716bea37a69c7fffe761dd40a3"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e28370eb8527ec3d1c6c61e081d6d44269af7af988bceb1faffa15bf59b0e7cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190a80a90e8f5118a96ca3ad1443390ee86c7310f7e72e741bef407e7ef52601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25ae75d3e393aff1d29d10e935d672838d5630be8eac2e0938bde18db5b4d12e"
    sha256 cellar: :any_skip_relocation, sonoma:        "873e480f627c6d7cb51af88120458b66c73c7b334089082d773ad78f791e68bf"
    sha256 cellar: :any_skip_relocation, ventura:       "9a4084012fb83640e41bfe2ab27e08f46d3976aac14dda930998197645b11903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44d454bdfebf515a6704fccee080174a0a400448e3ecfd266da337eb146c8d64"
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
