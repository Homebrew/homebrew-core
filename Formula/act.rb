class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.14.tar.gz"
  sha256 "bd18b6ba580d96fb6bd72ef34ebd12f947aadd1de7f4b3d07e363a8bea380dbc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3c2aada2a4226085f0932a72f55d4556107ca6b666659cb4f35a37e441b0923" => :catalina
    sha256 "e3eff949686197499c6f21a5df9787be6d0023e118130426f625cb47a948b552" => :mojave
    sha256 "d6d129d83c44f0d4194cd923c898b8c8bd5125a6836171be798bb2e3cfeea454" => :high_sierra
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
