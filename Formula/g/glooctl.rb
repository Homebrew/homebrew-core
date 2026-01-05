class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.20.7.tar.gz"
  sha256 "a1961311cbf1d2c2c9ee1b9c4773cd767bb51aabac00268652604690578227dd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12478e7053b05ae5fde9b7b70c2551d421383d0bad2d4e025bd3e4f8ad638f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a868a466a927d036c9e123ed3665db6a55b22f87b49712e49677143f1a3d1a6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ed07e9cf0b41fbc9db7ad78dc9550421df3d6c5d7b9fec1ea2d17c0481bc1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9526f0977f57373db7e7ee3b32becab270211165e8deb9f0f81b6ea02ff2c42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "134be858550650b76fef05f2f327765897c31ec5b18629b9b97db33de509de48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb3b91a2a2558a7555aaacbc81aee228f37ce065e91c276a44e4afee8dcf701"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/solo-io/gloo/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./projects/gloo/cli/cmd"

    generate_completions_from_executable(bin/"glooctl", shells: [:bash, :zsh], shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glooctl version 2>&1")

    assert_match "failed to create kube client", shell_output("#{bin}/glooctl get proxy 2>&1", 1)
  end
end
