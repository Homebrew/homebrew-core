class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "4d0a62de2afe4519324815570fbf0eea75edb7b29734844f403d91f13b32e034"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e37b4a1556f7e21331afe8de0320659a42d8a06fa7cdae07b0a135d43034e85d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e37b4a1556f7e21331afe8de0320659a42d8a06fa7cdae07b0a135d43034e85d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e37b4a1556f7e21331afe8de0320659a42d8a06fa7cdae07b0a135d43034e85d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9deb395b21f32a24472a809c0641fd70107ca6e63afc123f4eb2e887ce8d6b4c"
    sha256 cellar: :any,                 x86_64_linux:      "aaba3cc83c63b333e5f10d0fb2fe73c573cd8518d2a9911625874ecaacb5d361"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fetch --version")

    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.4.6\" --release-asset=\"SHA256SUMS\" . 2>&1")
  end
end
