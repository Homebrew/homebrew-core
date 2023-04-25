class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.16.3.tar.gz"
  sha256 "a3cc323cba5f75641da090858aebfd050d36cc34f0cb27b19c1fd520543f0546"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385202eefa9f98ae840449039a3af0d56315d4b0ca50dd4fbf7370d9e216c6d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "385202eefa9f98ae840449039a3af0d56315d4b0ca50dd4fbf7370d9e216c6d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "385202eefa9f98ae840449039a3af0d56315d4b0ca50dd4fbf7370d9e216c6d7"
    sha256 cellar: :any_skip_relocation, ventura:        "50f8a43e80115dcff622b3771ead78851a507824dd3fad9652c593944e62a62b"
    sha256 cellar: :any_skip_relocation, monterey:       "50f8a43e80115dcff622b3771ead78851a507824dd3fad9652c593944e62a62b"
    sha256 cellar: :any_skip_relocation, big_sur:        "50f8a43e80115dcff622b3771ead78851a507824dd3fad9652c593944e62a62b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2d16af2b1dc0e56ed8770242680f2eb2280f7f7791eb426dfcd416b1f2a620"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
