class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.14.3",
      revision: "7cc45095d4e0bebd44c8d2bbf97823856405cfd7"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3917129e772a74b65c0669772dfcdad1849d867d919b72404c3a700b646bda57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c656dab7927cd2a3585ac829a005aedd5f65b3397920fe32d67ae97f72a27673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9295b5397c584a261412347487d2025c5967eb6ae5363c2031d750adf6e51dd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5b4f305c64bf8f3f9d7ac23dcaaf6c6fa04e4a21e33e8516d82a3ad7e6937e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2045de75b0038e0e701d3a09a7693d67262c9087169d4071d29deea5522f3d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca5d0199e3b11c9ae35c05d7b47997028804424783425374acb73e04f078bfa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
