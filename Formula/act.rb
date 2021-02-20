class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.20.tar.gz"
  sha256 "523341e69f520946a67dcc51b03651bf29e595a8163d7262e763f43c6af0292b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "100f2beffca5042bd9ef4b06bbcc2e035b1a309d8d3005bf8fc0ca73aec69ccf"
    sha256 cellar: :any_skip_relocation, big_sur:       "fca37fbe614be35345521363bf02aa5b34ceb5a3c12dd389d9b3338740f5a34e"
    sha256 cellar: :any_skip_relocation, catalina:      "d8ed01206792faf3edb49cc0c23f0758a1bbbecb291321d607adc5c7f16aeb4a"
    sha256 cellar: :any_skip_relocation, mojave:        "cba5b986ce90051fb94b593fd59499a9d1072824d1ab0eb26094fae54a1e281a"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end
