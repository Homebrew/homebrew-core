class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.18.2",
      revision: "25a52e520f9c993711b93ea1111ed90c024e0528"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57e881014461d92030bc589bf3bbdf7988fbc7009f9fcb2f2c534157b2eb19e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c38f8153fe297dfb64591e24e75e142abf27a42b6b9032951e54512ba6d07eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91f529622008d50573b4e12c13309201930d91a4394a25f1863af74754ae286a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26aa449a21132519e3c0c9bf771180dfbaa9838bf4a24d8e1d66f66943b34625"
    sha256 cellar: :any,                 x86_64_linux:      "9f7d969daf6391c3e9ca4ff7a38426a1b70146fcc2eb3457e1560275a400502f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
