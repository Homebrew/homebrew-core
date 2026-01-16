class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.154.5.tar.gz"
  sha256 "bbb0cf908feb90b50adc010c100080177c43a938ef583224c4372d87534bdcaf"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768b4c06b7dd8630a2db308a25de2ca8e59461d98a8736203df319c747c4ad9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31341e44127b44a06b63673a8f22ac94ce6a50bf6f328886e9b3949f78ac24bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ba7d247c319bb16ed84ee8f9eb37c2eac5bf404f272cd2e6c63450ef07e942"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9bcd73e6d4275baec19e0843ada75583b1fb8170cc736882edba0a1f5ddb76d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38a5f1a8a6714685b8a7d5b6b93da8a02c40cc3fcd82271f6367b68102ea392d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5501154ddb424794fc26696ff8e6452599bb583faa855a19518d8770face3b93"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
