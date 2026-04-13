class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "88d11ad79663672fd3166661bdebfee67f2d3dc014d00c99c9cd9c99a651c2f7"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b89331ead5790c01aebd1da50b8ecfb1709512e2f2eee17925c3248ed60cf25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b89331ead5790c01aebd1da50b8ecfb1709512e2f2eee17925c3248ed60cf25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b89331ead5790c01aebd1da50b8ecfb1709512e2f2eee17925c3248ed60cf25"
    sha256 cellar: :any_skip_relocation, sonoma:        "da055b85ee3b67027afa73f2e0699f1fd560ac7f31440506fb18c45f2ea222e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a615dd68fb03a54c29759fb596859b56436b74b90a6127e3193a0fe036cff527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0880f79dcb1d49aad99e637db036e2faad141e10f19d844e97d4498b637e467e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
