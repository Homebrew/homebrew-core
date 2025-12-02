class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.30.0.tar.gz"
  sha256 "606b3ce45d1e64d28ac7729ee03480a8ee2c5e5a5c5122844bd9516f3cc1bcf3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b69222165e3992ec827f799080c99da6ddfb83b67a1cadb0279b5c1ed50dac4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b69222165e3992ec827f799080c99da6ddfb83b67a1cadb0279b5c1ed50dac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b69222165e3992ec827f799080c99da6ddfb83b67a1cadb0279b5c1ed50dac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3be0014a6a247423522c3e26074156aca20cecc640fe9bccef25d656b981c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03376dcde440d60bc146b0ceb6dc2d66387a73467ffdf0101dccda76c45dabcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569062400847b102f3c71673d130c11ec634b46fb656642f47b576b0bd5f3293"
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
