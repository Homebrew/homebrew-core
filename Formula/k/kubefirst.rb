class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.17.tar.gz"
  sha256 "3ce15c7ddad90cf221603fee3de8d6db8d33e4511a6826019d624bfbad5e2326"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dae91d370062f65300cdebdbdbdb88e043e7769276f0e26bfc2e0c8ac37655b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2484db4fa2835f95b478d8e81d9776940562633969c7459d61df1b35ef45fb9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2552ed2254413c27cc6b87c69c31d61d8e1d6d2759698fd653a17ff3f5fe751a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8601ddb29d01113d7f11f05c55bf11d7c0f120fe43d9ef15c24569e1ed782d70"
    sha256 cellar: :any_skip_relocation, ventura:        "103c764ef1fe730ffb966db7c59351b2bf37c2abfa712ee48473809acb8e5d99"
    sha256 cellar: :any_skip_relocation, monterey:       "f487938d679736ea4d2099a1caccb1ed1a5e2979e7e892dd5b1cec37f42e51eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f63bf4a82fc01b3750d6d6815317c35eeff8dadcfecbe730621e1b8eab78df"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
