class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.13.0",
      revision: "b76b65875d2e60d63ff571000f4c6c890c8dd70c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8a3123638adc44b8074be99ac86088e4aff930d4c9b9a9c2a7d2c40e38d1c1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07939b9b1aa03e4b54a2152d6e40f23946dc01807fc31b2b1cb554f649963216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d78bbcb63b9cf75e50fe139fe77e6286b9f8ce4ded6c20056fa9135b308b94a"
    sha256 cellar: :any_skip_relocation, ventura:        "92973d29a79582feb21b98d8242688f8941bb21191ac1da191f72c674ba92653"
    sha256 cellar: :any_skip_relocation, monterey:       "93b61af7903aa4643f92b9083772bae9f2bc054a655d2ab2eb18172cc80e90c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4a6ff525c777f31d4ff8449cb64a11437e666c0007eeb47138b9ff2b1e3306"
    sha256 cellar: :any_skip_relocation, catalina:       "d914dac67f7fee150db5ef63a5cbf21700d46bc5874b4d1ef595408313d9de56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee01e1c898d1a43031c73a9d6aef3937aa059150944c863e52095fec2a90d56b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
