class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.22.tar.gz"
  sha256 "eeca0c0b05249d28d404fb9c2000b1f79350d3b7ad61543ac594df7b0d93e8d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dc2ae4bb207b409956a8742829a65b6d3e4b2090332b597f7e3acfd01ffa0c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "48fc7e7abbda4494c471f73c21362f57a06b3a5e857be80a8856f6a2808c5b15"
    sha256 cellar: :any_skip_relocation, catalina:      "0924b01276060fc7f1063d69840bb928a4fd594a01b9ea561c58192dde580653"
    sha256 cellar: :any_skip_relocation, mojave:        "907341331521809d5822597a8ec000d6b0fa5a0c400807b5b76fa546de6c5b91"
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
