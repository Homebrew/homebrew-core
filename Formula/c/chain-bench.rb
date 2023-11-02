class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "debeff7a47acbe86f74b5cfdb970cb4843a547f3b363f56b3b45b89762dd5e60"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97cef43a8c089b898d15249f3ffb9276fc93008cadd96815ee5b430bb400b262"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df209c79574b5d0d913f488757e1afa4a49567cf86b1a3f8cfc6a478cd153f75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4668949ef3e0e9129f10514f9dc180ceaa7fc041819f8167136a150b51cdafeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3ace2a4675efbf65228b0a416eb178891a5959bfc56917f4bb977132ead703f"
    sha256 cellar: :any_skip_relocation, ventura:        "5d303f2016c65a2bb8b50a968b4dbe3e0476364659fb3566a0b1312d2fa8ea4f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ee4aa1f7393a4b5a1351d9742073aea62f0a391f8a0b65e7c2f6cab03025359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c10109a55d5bcaacd7ba652406fa29ccb3b26ccdf0d6bdf1633af8426ff5de4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    repo_url = "https://github.com/Homebrew/homebrew-core"
    assert_match "Fetch Starting", shell_output("#{bin}/chain-bench scan --repository-url #{repo_url}")

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
