class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.28.tar.gz"
  sha256 "010b9f02d2c431d9e09f5be1cf3099bd3fbab49043c53e34aa92b99bba8da3d1"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53252969cc7879a0db31fded88927092838530024e3926598c9b742ad4c47865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5ba70ba988bda3100b68ea7614092dc7c89c4306e7fcab8b6312961c430542d"
    sha256 cellar: :any_skip_relocation, monterey:       "e3fcd523e9f3e791b69907e478898df31e55534368fe96c44e270bcaa64e3965"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc1653252b938cb605e7e2ed6aea4c82768de8f9ce1ed62d1e0c8bc787a47810"
    sha256 cellar: :any_skip_relocation, catalina:       "ebdc25fb89e970d22838c80d55910f6d10e3b33057f3ac9e3f6374e2fdab9712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9da9d826f58c7395f529857c6bf50ba4482503aaf7b643a5ecee2783e1659c65"
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
