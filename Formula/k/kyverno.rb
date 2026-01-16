class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "c761cda4781a98d513d64467fc360a093b8b9b9225542c8a38d070faeb922261"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5d35b949ac6345bd92e44a83c1cb813c3a99f975a21c7af786f522026e42beb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a6531985055947f09527953230249923ed12098a17e2f147b28fc467e3298c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1bc3366994df72489d3aa3968b92d97cb9852b1e1fde10a5c65515aeebf471a"
    sha256 cellar: :any_skip_relocation, sonoma:        "03c48f7ae8b8807e03447828aadefcfc875543dd035b6e48d8305b08195d4c9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd25312c0c90e424c3632ed037a69745c42ab4ef6897f8f02d2ba5f48789325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09c98689eb96ef6853aeec7b812f5832a839913ddb17d461a52b7b2ae1689a8"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
