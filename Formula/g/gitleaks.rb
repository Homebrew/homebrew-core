class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.29.1.tar.gz"
  sha256 "d48deb58ae629e35d4913a3e6bf015255c5698610d513a46272cb0f98c8c65bd"
  license "MIT"
  head "https://github.com/gitleaks/gitleaks.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b84e3fb2b6f567da8a60933032093a5a280a64826600de74bb4193751f9e52d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b84e3fb2b6f567da8a60933032093a5a280a64826600de74bb4193751f9e52d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b84e3fb2b6f567da8a60933032093a5a280a64826600de74bb4193751f9e52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0f82a809fc87afc88b284b1f7fd7d77b0f545dff44fe172c777a22d50c0592"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a05773c2e35c9ae7f1d863f04689ed36653bddad1b9a1f86a69400549586c15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5a1c945695dc713025b9a8196ee80f8d471e1dbdab37b9b04e8be210d8defd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeef61dc214e36cbc4cee5eb6418e38d"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN.*leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
