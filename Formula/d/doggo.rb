class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "0266fe51cd7c6001011c3424380ff0f48809dcaf631fa65f51bfcbe66e59face"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d0033ab3cbcb4c31351174c58afdac844219fec933f6cd2faae2075d1cd2a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d0033ab3cbcb4c31351174c58afdac844219fec933f6cd2faae2075d1cd2a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d0033ab3cbcb4c31351174c58afdac844219fec933f6cd2faae2075d1cd2a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "de71149e98f29d79539c1e1400a25678a3d3f6fe769e4dac818acb0c82544a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5b07a4d10836691161cc8db741759954d816276392de74b872802dd41074fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6082e855c991757fa18b411a4bf269682a8ce74be7c730108916d827bcf4fc49"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
