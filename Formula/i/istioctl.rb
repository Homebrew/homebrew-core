class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.25.2.tar.gz"
  sha256 "a9eadb5bccf3de29caafd8f203d47c0c3d77faa940b2f025bdd49c626bdf9174"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac210c1d47305390d3281da99f81469446b0e7883b4144743ea1177b7d9d900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47298a72fff36870fa97d893d50ee81b7d0cc9ffe9ad14ae78cadbc428fe1e75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "812d6f58d8ab72c7ac68ce01d3dc9e0add2d0f1b5aaa742c4449a5172c3d4d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b45ffac1f3af269b65b4969ca10c59a9475190dec3e619b7f7b51bc0fedb988"
    sha256 cellar: :any_skip_relocation, ventura:       "dc5b2ff4f88a7ad02a440420ffb98616d126413c38e4a72614be220b7bfd7343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f95d831eb0dec3f3119cd8ab4b853fd9123691c4ace3c190bd4815afb905fdde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9c70ed05a9e9d3d752f0f8bc4fe2e3511131ed9e71c5fbea92240ec4c369a27"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
