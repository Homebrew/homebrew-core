class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.16.tar.gz"
  sha256 "e67812743a37cc50bbf80403eea9ac957b5a4a056b4f28b21e1aaabdd270ca22"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f07dbc4d2b860661513a7e345179c95cf3d13dcf9061508885be2993ee35975" => :catalina
    sha256 "63aa66b44617c85b5d4b2d9e6db8d2adf97909c85f312d40abe5fd8ad8ecb2ed" => :mojave
    sha256 "8e5bcd4db6828643ca780f0e8e1a85f324cb7dfa57ea11965b5f882f74cb98f1" => :high_sierra
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
