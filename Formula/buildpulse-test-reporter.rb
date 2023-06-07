class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "63604db79aa165eff8fb31e08432b4c95685748b44022dd2b97f1bf5cca71e01"
  license "MIT"
  revision 1
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ebba7785369dec61ca485c4255be696fb39607b86a942999c803969786f09c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ebba7785369dec61ca485c4255be696fb39607b86a942999c803969786f09c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10ebba7785369dec61ca485c4255be696fb39607b86a942999c803969786f09c"
    sha256 cellar: :any_skip_relocation, ventura:        "9c60179834de6ef9d87089bfb80e0bb8ce04f4c52cc479de59ef2ecd05fadafa"
    sha256 cellar: :any_skip_relocation, monterey:       "9c60179834de6ef9d87089bfb80e0bb8ce04f4c52cc479de59ef2ecd05fadafa"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c60179834de6ef9d87089bfb80e0bb8ce04f4c52cc479de59ef2ecd05fadafa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff5d675a148310f2cc6766c3ecd33b65427f4023c023e6f909e48c7da0edb05"
  end

  depends_on "go" => :build

  # Fix support for 64-bit GITHUB_RUN_ID.
  # Remove with the next release.
  patch :DATA

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end

__END__
diff --git a/internal/metadata/providers.go b/internal/metadata/providers.go
index 7ac32fe..13892b1 100644
--- a/internal/metadata/providers.go
+++ b/internal/metadata/providers.go
@@ -183,7 +183,7 @@ type githubMetadata struct {
 	GithubRepoNWO    string `env:"GITHUB_REPOSITORY" yaml:"-"`
 	GithubRepoURL    string `yaml:":github_repo_url"`
 	GithubRunAttempt uint   `env:"GITHUB_RUN_ATTEMPT" yaml:":github_run_attempt"`
-	GithubRunID      uint   `env:"GITHUB_RUN_ID" yaml:":github_run_id"`
+	GithubRunID      uint64 `env:"GITHUB_RUN_ID" yaml:":github_run_id"`
 	GithubRunNumber  uint   `env:"GITHUB_RUN_NUMBER" yaml:":github_run_number"`
 	GithubServerURL  string `env:"GITHUB_SERVER_URL" yaml:"-"`
 	GithubSHA        string `env:"GITHUB_SHA" yaml:"-"`
