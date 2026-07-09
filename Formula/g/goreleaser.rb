class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.17.0",
      revision: "770a4fc7a8fb2dca874b6c98cb739dd64fc931c0"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b932ee0ecb64b8e022a58527ab7eb724092de89ebeae027fda159f09dc2e1afe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916486227deb180f19ae8fcede7202b0236372d7573534f05647c1985d4c9e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9561fcb7dd7787c85b6132c74346be770c0497dc84cc7d8e970d946b315d07df"
    sha256 cellar: :any_skip_relocation, sonoma:        "677e3208a471d60d95929f946230a702dd6132c58f6d3442201bf2bc6fe306ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8c3ce013fe92ac7a70af5f27d22f5e2b31dca3442f9d62f89ccc0152570a86d"
    sha256 cellar: :any,                 x86_64_linux:  "70580ca2c53de3392d23fb5452d5a0b7c908df8b65451565022f8c0269cfa276"
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
