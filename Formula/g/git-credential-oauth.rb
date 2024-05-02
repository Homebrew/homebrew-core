class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "1701316840133951f7ba3c2c085b3e92c0ac8c3f1ae8e76400c234c9d74f0722"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4417ec7b760e6da45564cfb23737387e541e095449bb42e66a5d75cf5b91e140"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b968fcc700980dc2d552cdac7f922fa73d6c38657da4648467e486485e93e062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2275a71c23a2b06d043680ec9339c311141ec7827a4cb6fd409843bdd0ad21"
    sha256 cellar: :any_skip_relocation, sonoma:         "b42dd9922841436c9ac58277b4aa36085f53e164563cd6b6a70023ea9d9e5000"
    sha256 cellar: :any_skip_relocation, ventura:        "aea519246d0604565e1517f0f1826b8e42cf0f25b4b0aaa49acec2b0893faf65"
    sha256 cellar: :any_skip_relocation, monterey:       "3287c2ca2e5261acc7d6ac70c4fb16ea4bd40e14fa9cd98ad8620831801e4cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b8435f98b31a4aaba6e3788c399f7ea2c8530e0293b8988ced690a560b3b55e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
