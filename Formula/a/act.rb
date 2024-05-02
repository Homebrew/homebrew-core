class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.62.tar.gz"
  sha256 "2b0231d02d57d5edbcc070b7c4802acf16110a0582ffb40181aaa695f2b7bf5c"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca272eda5a06d47a251f3488102b236ebf14087f5287909b2a9598edd924ac53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f23b97ce5a9e6e7f03f7fb63bd6cf22c9826f3791b44454ffe1e6d6c49fd76a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa121151ee94ebe00bb5defd9440b7b3740b456b6cf26d751e171cf807b5101"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cfbf32a5c2dd7dc21cc7932ea20d1bd421526f33c953bb5f7d9f31152601051"
    sha256 cellar: :any_skip_relocation, ventura:        "6cf13f39c5aaceed5510c6cbb51a1a4358aecc433f54cd261ab723ee0fffe69e"
    sha256 cellar: :any_skip_relocation, monterey:       "485913ba7c4ed6f3b160684a83188f12e0b186c04d4e5362886695f9ce2526c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae0cde4b9f2364d50b474f8a40ecd3a3507b44e976e9c0cb53ef7e76b6d920b3"
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
