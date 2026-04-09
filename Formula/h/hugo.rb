class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.160.1.tar.gz"
  sha256 "aaab9991fcc691aba35f8702c3cec65e2ba074408de70a9f66f7b868c28b8cdf"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7fb0ffa079d16822cb97802dcd4115039977cc1ced5d4e2df5d35d4855db0be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b8c8b5a1dd46505428d9d14e491b4c50492f456ac6cf1efbd853f6eea2da7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edbfc89b4c0557ed9b53cfd441e865cd76bc74afb73d28b6b048c16ce318e38d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8c3fb31bb149ea0806b3e77929c2bd6f010409964c56626e82a1afcd8fa5849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb564fd05ff862252f4dba8cd80ebb4b0338a17cb57e16e7e261d51cba1e09d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f486eb0b7cfb884cd8227cfe8be26a85a065849ceabf95ee38933747ae2cdcd"
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
