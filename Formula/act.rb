class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.10.tar.gz"
  sha256 "1e4d371cfa6aec7e350927e55c3ac8413dbf6e23edbb811ebe2d587dbf136928"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "056167aa7eec2e5229a0f50b43d3bcd4845fadef990cd29d65a13b316449dc06" => :catalina
    sha256 "1e6ab1ae827952962a92b1bcd82643b950edd446b87f6f991bcd6ad333de0852" => :mojave
    sha256 "c8ac56be5db0a72aa5eac9c8f8937c5c52386e45d0f364ad9c63a7cba04db39d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
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
