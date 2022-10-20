class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.32.tar.gz"
  sha256 "1d97468200aeae51cef70bc0b7c7497854d7fb512720768e2aba8d9661a28fc7"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1352a308c4fb2aef385ab35b12af1f5cf8e424addaea5e8c3c59e1b66797abaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f408433a1f0eee8accdfef5548ef36703fee0ad47e121e77fe661ee068b8bb76"
    sha256 cellar: :any_skip_relocation, monterey:       "802d1a6a9644cabc1e1c78fb110ebad9ce34b82097051d6c9a94de8379155931"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d10f31b50570dc0c7fd0a44d651b22ca8e69693ae2bb19a783c1322bd27bd97"
    sha256 cellar: :any_skip_relocation, catalina:       "d4ca2b14943b769e5a68cc8bf711dc9dd4929813fd586f756f45ba07896aaf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a7cb683d4a3182298aa088d1ec7e6cff03d623284d3ba18a5973692bd63e6f8"
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
